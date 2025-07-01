import 'package:flutter/foundation.dart';
import 'package:front_mission/data/model/board_list.dart';
import 'package:front_mission/data/model/board_list_response.dart';
import 'package:front_mission/domain/usecase/sign_out_use_case.dart';

import '../../domain/usecase/board_list_use_case.dart';

class BoardScreenViewModel extends ChangeNotifier {
  final BoardListUseCase _boardListUseCase;
  final SignOutUseCase _signOutUseCase;

  BoardScreenViewModel({
    required BoardListUseCase boardListUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _boardListUseCase = boardListUseCase,
       _signOutUseCase = signOutUseCase;

  List<BoardList> _boards = [];

  List<BoardList> get boards => _boards;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? errorMessage;

  int _currentPage = 0;
  int _totalPages = 1;
  final int _pageSize = 10;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  Future<void> fetchBoards({int page = 0}) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final BoardListResponse response = await _boardListUseCase.execute(
        page: page,
        size: _pageSize,
      );

      _boards = response.boards;
      _currentPage = page;
      _totalPages = response.totalPages;
    } catch (e) {
      errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _signOutUseCase.execute();
    } catch (e) {
      errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
