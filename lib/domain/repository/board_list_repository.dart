import '../../data/model/board_list.dart';

abstract interface class BoardListRepository {
  Future<List<BoardList>> listBoard({int page, int size});
}
