import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import '../models/post.dart';
import '../services/api_service.dart';
import 'add_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  PostsScreenState createState() => PostsScreenState();
}

class PostsScreenState extends State<PostsScreen> {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _apiService.getPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar posts: $e')),
        );
      }
    }
  }

  void _toggleLike(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      if (post.isLiked) {
        post.likeCount++;
      } else {
        post.likeCount--;
      }
    });
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.white,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Posts',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: _posts.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum post encontrado',
                        style: GoogleFonts.inter(),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Image.memory(
                                base64Decode(post.imagem.split(',').last),
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  post.texto,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: post.isLiked ? Colors.red : Colors.white,
                                      ),
                                      onPressed: () => _toggleLike(post),
                                    ),
                                    Text(
                                      '${post.likeCount}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
          _loadPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
