import 'dart:convert';
import 'dart:typed_data';

import 'package:front_mission/data/model/board.dart';
import 'package:front_mission/data/model/detail_board.dart';
import 'package:front_mission/domain/repository/detail_board_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/token_manager.dart';

class DetailBoardRepositoryImpl implements DetailBoardRepository {
  final TokenManager _tokenManager;

  DetailBoardRepositoryImpl({required TokenManager tokenManager})
    : _tokenManager = tokenManager;

  @override
  Future<DetailBoard> detailBoard(int id) async {
    final String? jwtToken = _tokenManager.jwtToken;
    if (jwtToken == null) {
      print('게시글 작성 실패: JWT 토큰이 없습니다.');
    }
    final uri = Uri.parse('https://front-mission.bigs.or.kr/boards/$id');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $jwtToken'},
    );
    if (response.statusCode != 200) {
      final String errorMessage =
          'Failed to fetch boards: HTTP Status ${response.statusCode} - ${response.body}';
      print('🚨 게시글 목록 불러오기 실패: $errorMessage');
    }
    final Map<String, dynamic> responseData = json.decode(
      utf8.decode(response.bodyBytes),
    );
    return DetailBoard.fromJson(responseData);
  }

  @override
  Future<void> deleteBoard(int id) async {
    final String? jwtToken = _tokenManager.jwtToken;
    if (jwtToken == null) {
      print('게시글 작성 실패: JWT 토큰이 없습니다.');
    }
    final uri = Uri.parse('https://front-mission.bigs.or.kr/boards/$id');
    try {
      http.Response response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $jwtToken', // 인증 헤더 추가
        },
      );
      if (response.statusCode != 200) {
        print('Failed to delete post: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete post: $error');
    }
  }

  @override
  Future<Board> patchBoard(int id, Board board, XFile? imageFile) async {
    final String? jwtToken = _tokenManager.jwtToken;
    if (jwtToken == null) {
      print('게시글 작성 실패: JWT 토큰이 없습니다.');
    }

    final uri = Uri.parse('https://front-mission.bigs.or.kr/boards/$id');
    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $jwtToken';

    final requestJson = jsonEncode(board.toJson());
    request.files.add(
      http.MultipartFile.fromString(
        'request',
        requestJson,
        contentType: MediaType('application', 'json'),
      ),
    );

    if (imageFile != null) {
      final Uint8List bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
          contentType: imageFile.mimeType != null
              ? MediaType.parse(imageFile.mimeType!)
              : MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('게시글 수정 실패: ${response.statusCode} - ${response.body}');
    }
    final responseBody = utf8.decode(response.bodyBytes);
    if (responseBody.trim().isEmpty) {
      return board; // 서버에서 본문이 아예 없거나 공백만 보낸 경우
    }

    final responseData = json.decode(utf8.decode(response.bodyBytes));
    return Board.fromJson(responseData);
  }
}
