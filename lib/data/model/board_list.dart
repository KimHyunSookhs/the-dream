class BoardList {
  final int? id;
  final String? title;
  final String? category;
  final String? createdAt;

  const BoardList({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
  });

  factory BoardList.fromJson(Map<String, dynamic> json) {
    return BoardList(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'createdAt': createdAt,
  };
}
