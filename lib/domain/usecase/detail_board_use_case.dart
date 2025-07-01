import 'package:front_mission/data/model/detail_board.dart';
import 'package:front_mission/domain/repository/detail_board_repository.dart';

class DetailBoardUseCase {
  final DetailBoardRepository detailBoardRepository;

  DetailBoardUseCase({required this.detailBoardRepository});

  Future<DetailBoard> execute(int id) async {
    final board = await detailBoardRepository.detailBoard(id);
    return board;
  }
}
