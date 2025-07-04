import 'package:flutter/foundation.dart';
import 'package:front_mission/domain/usecase/write_board_use_case.dart';
import 'package:image_picker/image_picker.dart';

class WriteBoardViewModel with ChangeNotifier {
  final WriteBoardUseCase _writeBoardUseCase;

  WriteBoardViewModel({required WriteBoardUseCase writeBoardUseCase})
    : _writeBoardUseCase = writeBoardUseCase;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<bool> writeBoard(
    String title,
    String content,
    String category,
    XFile? image,
  ) async {
    try {
      await _writeBoardUseCase.execute(title, content, category, image);
      return true; // 성공
    } catch (e) {
      _error = e.toString();
      print("게시글 작성 실패: $_error");
      return false; // 실패
    }
  }
}
