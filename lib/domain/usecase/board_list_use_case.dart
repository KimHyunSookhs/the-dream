import 'package:front_mission/domain/repository/board_list_repository.dart';

import '../../data/model/board_list.dart';

class BoardListUseCase {
  final BoardListRepository _repository;

  BoardListUseCase({required BoardListRepository repository})
    : _repository = repository;

  Future<List<BoardList>> execute({int page = 0, int size = 10}) async {
    final List<BoardList> boards = await _repository.listBoard(
      page: page,
      size: size,
    );
    return boards;
  }
}
