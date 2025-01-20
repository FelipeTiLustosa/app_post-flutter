import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class Post {
  final int id;
  final String texto;
  final String imagem;
  bool isLiked; // Novo campo para representar o status de like
  int likeCount; // Novo campo para a contagem de likes

  Post({
    required this.id,
    required this.texto,
    required this.imagem,
    this.isLiked = false,
    this.likeCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'texto': texto,
        'imagem': imagem,
        'isLiked': isLiked,
        'likeCount': likeCount,
      };

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      texto: json['texto'],
      imagem: json['imagem'],
      isLiked: json['isLiked'] ?? false,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}

class ApiService {
  final List<Post> _posts = [];
  int _nextId = 1;

  Router get router {
    final router = Router();

    // GET /posts
    router.get('/posts', (Request request) {
      return Response.ok(
        json.encode(_posts.map((post) => post.toJson()).toList()),
        headers: {
          'content-type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': '*',
        },
      );
    });

    // POST /posts
    router.post('/posts', (Request request) async {
      try {
        final payload = await request.readAsString();
        print('Received payload: $payload'); // Debug log
        
        final Map<String, dynamic> body = json.decode(payload);
        
        final post = Post(
          id: _nextId++,
          texto: body['texto'],
          imagem: body['imagem'],
        );

        _posts.add(post);
        
        return Response.ok(
          json.encode(post.toJson()),
          headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          },
        );
      } catch (e) {
        print('Error processing request: $e'); // Debug log
        return Response.internalServerError(
          body: json.encode({'error': e.toString()}),
          headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          },
        );
      }
    });

    // POST /posts/<postId>/like
    router.post('/posts/<postId>/like', (Request request, String postId) {
      try {
        final id = int.parse(postId);
        final postIndex = _posts.indexWhere((post) => post.id == id);
        
        if (postIndex != -1) {
          // Toggle like status e atualiza contagem
          final post = _posts[postIndex];
          post.isLiked = !post.isLiked;
          post.likeCount += post.isLiked ? 1 : -1;
          
          return Response.ok(
            json.encode(post.toJson()),
            headers: {
              'content-type': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
              'Access-Control-Allow-Headers': '*',
            },
          );
        }
        
        return Response.notFound('Post não encontrado');
      } catch (e) {
        return Response.internalServerError(
          body: json.encode({'error': e.toString()}),
          headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          },
        );
      }
    });

    // OPTIONS handler for CORS preflight requests
    router.options('/<ignored|.*>', (Request request) {
      return Response.ok('',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          });
    });

    return router;
  }
}

void main() async {
  final service = ApiService();
  
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) {
        return (request) async {
          // Add CORS headers to all responses
          var response = await innerHandler(request);
          return response.change(headers: {
            ...response.headers,
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          });
        };
      })
      .addHandler(service.router);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
