import 'board_list.dart';

class BoardListResponse {
  final List<BoardList> boards;
  final int totalPages;
  final int totalElements;

  BoardListResponse({
    required this.boards,
    required this.totalPages,
    required this.totalElements,
  });

  factory BoardListResponse.fromJson(Map<String, dynamic> json) {
    return BoardListResponse(
      boards: (json['content'] as List)
          .map((item) => BoardList.fromJson(item))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
    );
  }
}
