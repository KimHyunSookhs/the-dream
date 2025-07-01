import 'package:front_mission/domain/repository/board_list_repository.dart';

import '../../data/model/board_list_response.dart';

class BoardListUseCase {
  final BoardListRepository _repository;

  BoardListUseCase({required BoardListRepository repository})
    : _repository = repository;

  Future<BoardListResponse> execute({int page = 0, int size = 10}) async {
    return await _repository.listBoard(page: page, size: size);
  }
}
