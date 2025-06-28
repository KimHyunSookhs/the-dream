import 'package:flutter/foundation.dart';
import 'package:front_mission/domain/usecase/write_board_use_case.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repository/write_board_repository_impl.dart';
import '../../domain/repository/write_board_repository.dart';

class WriteBoardViewModel with ChangeNotifier {
  final WriteBoardUseCase _writeBoardUseCase;
  final WriteBoardRepository _writeBoardRepository;

  WriteBoardViewModel({
    required WriteBoardUseCase writeBoardUseCase,
    required WriteBoardRepository writeBoardRepository,
  }) : _writeBoardUseCase = writeBoardUseCase,
       _writeBoardRepository = writeBoardRepository;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  void setJwtToken(String token) {
    if (_writeBoardRepository is WriteBoardRepositoryImpl) {
      (_writeBoardRepository as WriteBoardRepositoryImpl).updateJwtToken(token);
    }
  }

  Future<void> writeBoard(
    String title,
    String content,
    String category,
    XFile? image,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _writeBoardUseCase.execute(title, content, category, image);
    } catch (e) {
      _error = e.toString();
      print("게시글 작성 실패: $_error");
    }
    notifyListeners();
  }
}
