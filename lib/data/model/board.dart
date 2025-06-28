class Board {
  final String? title;
  final String? content;
  final String? category;
  final String? image;

  const Board({
    required this.title,
    required this.content,
    required this.category,
    this.image,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      title: json['title'],
      content: json['content'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'category': category,
    if (image != null) 'image': image,
  };
}
