import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  final http.Client _client;

  ApiService([http.Client? client]) : _client = client ?? http.Client();

  Future<List<Post>> getPosts() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('GET Response status: ${response.statusCode}');
      print('GET Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar posts: $e');
      throw Exception('Erro ao carregar posts: $e');
    }
  }

  Future<Post> createPost(String texto, String imagem) async {
    try {
      print('Enviando post...');
      print('Texto: $texto');
      print('Tamanho da imagem: ${imagem.length}');

      final response = await _client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'texto': texto,
          'imagem': imagem,
        }),
      );

      print('POST Response status: ${response.statusCode}');
      print('POST Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao criar post: $e');
      throw Exception('Erro ao criar post: $e');
    }
  }

  Future<void> toggleLike(int postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/like');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('LIKE Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Falha ao curtir post');
      }
    } catch (e) {
      print('Erro ao curtir post: $e');
      throw Exception('Erro ao curtir post: $e');
    }
  }
}
