import 'package:flutter/foundation.dart';
import 'package:front_mission/data/model/board_list.dart';
import 'package:front_mission/data/model/board_list_response.dart';

import '../../domain/usecase/board_list_use_case.dart';

class BoardScreenViewModel extends ChangeNotifier {
  final BoardListUseCase _boardListUseCase;

  List<BoardList> _boards = [];

  List<BoardList> get boards => _boards;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? errorMessage;

  int _currentPage = 0;
  int _totalPages = 1;
  final int _pageSize = 10;

  BoardScreenViewModel({required BoardListUseCase boardListUseCase})
    : _boardListUseCase = boardListUseCase;

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
}
