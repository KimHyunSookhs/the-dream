import 'dart:convert';

import 'package:front_mission/data/model/board_list.dart';
import 'package:front_mission/domain/repository/board_list_repository.dart';
import 'package:http/http.dart' as http;

import '../../core/token_manager.dart';
import '../model/board_list_response.dart';

class BoardListRepositoryImpl implements BoardListRepository {
  final String _baseUrl = 'https://front-mission.bigs.or.kr';
  final TokenManager _tokenManager;

  BoardListRepositoryImpl({required TokenManager tokenManager})
    : _tokenManager = tokenManager;

  @override
  Future<BoardListResponse> listBoard({int page = 0, int size = 10}) async {
    final jwtToken = _tokenManager.jwtToken;
    if (jwtToken == null) throw Exception('토큰이 없습니다.');

    final uri = Uri.parse('$_baseUrl/boards?page=$page&size=$size');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final data = json.decode(utf8.decode(response.bodyBytes));

    final boards = (data['content'] as List)
        .map((item) => BoardList.fromJson(item))
        .toList();

    return BoardListResponse(
      boards: boards,
      totalPages: data['totalPages'] ?? 1,
      totalElements: data['totalElements'] ?? boards.length,
    );
  }
}
