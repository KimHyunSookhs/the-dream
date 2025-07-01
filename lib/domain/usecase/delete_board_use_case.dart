import '../repository/detail_board_repository.dart';

class DeleteBoardUseCase {
  final DetailBoardRepository detailBoardRepository;

  DeleteBoardUseCase({required this.detailBoardRepository});

  Future<void> execute(int id) async {
    await detailBoardRepository.deleteBoard(id);
  }
}

