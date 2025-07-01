class DetailBoard {
  final int? id;
  final String? title;
  final String? content;
  final String? boardCategory;
  final String? imageUrl;
  final String? createdAt;

  const DetailBoard({
    required this.title,
    required this.content,
    required this.boardCategory,
    required this.id,
    required this.createdAt,
    this.imageUrl,
  });

  factory DetailBoard.fromJson(Map<String, dynamic> json) {
    return DetailBoard(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      boardCategory: json['boardCategory'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'boardCategory': boardCategory,
    'createdAt': createdAt,
    if (imageUrl != null) 'imageUrl': imageUrl,
  };
}
