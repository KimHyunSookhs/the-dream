import 'dart:convert';
import 'dart:typed_data';

import 'package:front_mission/domain/repository/write_board_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class WriteBoardRepositoryImpl implements WriteBoardRepository {
  String? _jwtToken;

  WriteBoardRepositoryImpl({String? jwtToken}) : _jwtToken = jwtToken;

  void updateJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
  }

  @override
  Future<void> writeBoard(
    String title,
    String content,
    String category,
    XFile? imageFile,
  ) async {
    if (_jwtToken == null) {
      print('게시글 작성 실패: JWT 토큰이 없습니다.');
    }

    final uri = Uri.parse('https://front-mission.bigs.or.kr/boards');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_jwtToken';

    final textData = {"title": title, "content": content, "category": category};
    final textJson = json.encode(textData);
    request.files.add(
      http.MultipartFile.fromString(
        'request',
        textJson,
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

    // 요청 전송
    final response = await request.send();

    // 응답 처리
    if (response.statusCode == 201) {
      print(textData);
      print("게시글 등록 성공");
    } else {
      print("게시글 등록 실패: ${response.statusCode}");
    }
  }
}
