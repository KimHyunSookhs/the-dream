import 'package:front_mission/data/model/board.dart';
import 'package:image_picker/image_picker.dart';

import '../repository/detail_board_repository.dart';

class PatchBoardUseCase {
  final DetailBoardRepository detailBoardRepository;

  PatchBoardUseCase({required this.detailBoardRepository});

  Future<Board> execute(int id, Board board, XFile? imageFile) async {
    return await detailBoardRepository.patchBoard(id, board, imageFile);
  }
}
