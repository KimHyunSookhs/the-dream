import 'package:flutter/foundation.dart'; // ChangeNotifier를 위해 필요
import 'package:front_mission/data/model/board_list.dart';

import '../../domain/usecase/board_list_use_case.dart'; // BoardList 모델 임포트

class BoardScreenViewModel extends ChangeNotifier {
  final BoardListUseCase _boardListUseCase;

  // 게시글 목록 데이터를 저장하는 변수. 초기값은 빈 리스트.
  List<BoardList> _boards = [];

  List<BoardList> get boards => _boards; // 외부에 공개되는 getter

  // 데이터 로딩 중인지 나타내는 상태 변수.
  bool _isLoading = false;

  bool get isLoading => _isLoading; // 외부에 공개되는 getter

  // 에러 메시지를 저장하는 상태 변수.
  String? _errorMessage;

  String? get errorMessage => _errorMessage; // 외부에 공개되는 getter

  BoardScreenViewModel({required BoardListUseCase boardListUseCase})
    : _boardListUseCase = boardListUseCase;

  Future<void> fetchBoards() async {
    _isLoading = true; // 로딩 시작
    _errorMessage = null; // 에러 메시지 초기화
    notifyListeners(); // View에 상태 변경 알림

    try {
      final List<BoardList> fetchedBoards = await _boardListUseCase.execute(
        page: 0, // 첫 페이지를 가져옵니다. 필요에 따라 동적으로 변경 가능
        size: 10, // 한 페이지당 10개 게시글을 가져옵니다. 필요에 따라 동적으로 변경 가능
      );
      _boards = fetchedBoards; // 성공적으로 가져온 데이터로 _boards 업데이트
    } catch (e) {
      _errorMessage = '게시글 목록 로드 실패: $e';
      print('🚨 ViewModel 에러: $_errorMessage'); // 콘솔에 에러 출력 (디버깅용)
    } finally {
      _isLoading = false; // 로딩 종료
      notifyListeners(); // View에 최종 상태 변경 알림
    }
  }
}
