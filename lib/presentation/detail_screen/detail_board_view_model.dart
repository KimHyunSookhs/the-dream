import 'package:flutter/foundation.dart'; // ChangeNotifier를 위해 필요
import 'package:front_mission/data/model/board.dart';
import 'package:front_mission/data/model/detail_board.dart';
import 'package:front_mission/domain/usecase/delete_board_use_case.dart';
import 'package:front_mission/domain/usecase/detail_board_use_case.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/usecase/patch_board_use_case.dart';

class DetailBoardViewModel extends ChangeNotifier {
  final DetailBoardUseCase _useCase;
  final DeleteBoardUseCase _deleteBoardUseCase;
  final PatchBoardUseCase _patchBoardUseCase;

  DetailBoardViewModel({
    required DetailBoardUseCase useCase,
    required DeleteBoardUseCase deleteBoardUseCase,
    required PatchBoardUseCase patchBoardUseCase,
  }) : _useCase = useCase,
       _deleteBoardUseCase = deleteBoardUseCase,
       _patchBoardUseCase = patchBoardUseCase;

  DetailBoard? _board;

  DetailBoard? get board => _board;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> fetchBoard(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final DetailBoard fetchedBoard = await _useCase.execute(id);
      _board = fetchedBoard;
    } catch (e) {
      _errorMessage = '게시글 목록 로드 실패: $e';
      print('ViewModel 에러: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBoard(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _deleteBoardUseCase.execute(id);
    } catch (e) {
      _errorMessage = '게시글 삭제 실패: $e';
      print('ViewModel 에러: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Board> patchBoard(int id, Board board, XFile? imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final patch = _patchBoardUseCase.execute(id, board, imageFile);
      return patch;
    } catch (e) {
      _errorMessage = '게시글 삭제 실패: $e';
      print('ViewModel 에러: $_errorMessage');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
