import 'package:front_mission/data/model/board.dart';
import 'package:front_mission/data/model/detail_board.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class DetailBoardRepository {
  Future<DetailBoard> detailBoard(int id);

  Future<void> deleteBoard(int id);

  Future<Board> patchBoard(int id, Board board, XFile? imageFile);
}
