class Post {
  final int id;
  final String texto;
  final String imagem;
  bool isLiked; // novo campo
  int likeCount; // novo campo

  Post({
    required this.id, 
    required this.texto, 
    required this.imagem,
    this.isLiked = false, // valor padrão
    this.likeCount = 0, // valor padrão
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      texto: json['texto'],
      imagem: json['imagem'],
      isLiked: json['isLiked'] ?? false,
      likeCount: json['likeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'texto': texto,
    'imagem': imagem,
    'isLiked': isLiked,
    'likeCount': likeCount,
  };
}