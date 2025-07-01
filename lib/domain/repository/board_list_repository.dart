import '../../data/model/board_list_response.dart';

abstract interface class BoardListRepository {
  Future<BoardListResponse> listBoard({int page = 0, int size = 10});
}
