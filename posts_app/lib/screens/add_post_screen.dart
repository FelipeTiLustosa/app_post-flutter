import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../services/api_service.dart';
import '../models/post.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  AddPostScreenState createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  final _textController = TextEditingController();
  final _apiService = ApiService();
  String? _imageBase64;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _submitPost() async {
    if (_imageBase64 == null || _textController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.createPost(_textController.text, _imageBase64!);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar post: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Post'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de texto melhorado com fundo e cor do texto
              TextField(
                controller: _textController,
                maxLines: null,
                minLines: 4,
                style: const TextStyle(
                  color: Colors.white, // Cor do texto branco
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  labelText: 'Texto do Post',
                  labelStyle: const TextStyle(color: Colors.white), // Cor da label
                  hintText: 'Escreva algo...',
                  hintStyle: const TextStyle(color: Colors.white54), // Cor do placeholder
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Botão de selecionar imagem
              ElevatedButton(
                onPressed: _isLoading ? null : _pickImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Carregando...' : 'Selecionar Imagem',
                  style: const TextStyle(
                    color: Colors.white, // Cor do texto no botão
                    fontSize: 16,
                  ),
                ),
              ),

              if (_imageBase64 != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(_imageBase64!.split(',').last),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Botão de enviar post com indicador de carregamento
              ElevatedButton(
                onPressed: _isLoading || _imageBase64 == null || _textController.text.isEmpty
                    ? null
                    : _submitPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Enviar Post',
                        style: TextStyle(
                          color: Colors.white, // Cor do texto no botão
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
