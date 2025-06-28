import 'dart:convert';

import 'package:front_mission/data/model/board_list.dart';
import 'package:front_mission/domain/repository/board_list_repository.dart';
import 'package:http/http.dart' as http;

import '../../core/token_manager.dart';

class BoardListRepositoryImpl implements BoardListRepository {
  final String _baseUrl = 'https://front-mission.bigs.or.kr';
  final TokenManager _tokenManager;

  BoardListRepositoryImpl({required TokenManager tokenManager})
    : _tokenManager = tokenManager;

  @override
  Future<List<BoardList>> listBoard({int page = 0, int size = 10}) async {
    final String? jwtToken = _tokenManager.jwtToken;

    if (jwtToken == null) {
      throw Exception('토큰이 없습니다.');
    }
    try {
      final Uri uri = Uri.parse('$_baseUrl/boards?page=$page&size=$size');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $jwtToken', // 'Bearer' 접두사 필수
        },
      );
      if (response.statusCode != 200) {
        final String errorMessage =
            'Failed to fetch boards: HTTP Status ${response.statusCode} - ${response.body}';
        print('🚨 게시글 목록 불러오기 실패: $errorMessage');
        throw Exception(errorMessage);
      }
      final Map<String, dynamic> responseData = json.decode(
        utf8.decode(response.bodyBytes),
      );
      if (responseData['content'] is List) {
        final List<dynamic> boardList = responseData['content'];
        final List<BoardList> boards = boardList
            .map((item) => BoardList.fromJson(item as Map<String, dynamic>))
            .toList();
        return boards;
      } else {
        final String errorMessage =
            "'content' field is not a list or is null in response.";
        print('🚨 데이터 파싱 실패: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (error) {
      final String errorMessage = 'Failed to fetch boards: $error';
      print('🚨 네트워크 오류 또는 알 수 없는 에러: $errorMessage');
      throw Exception(errorMessage); // 예외를 상위 계층으로 전달합니다.
    }
  }
}
