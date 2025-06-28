import 'package:front_mission/domain/repository/write_board_repository.dart';
import 'package:image_picker/image_picker.dart';

class WriteBoardUseCase {
  final WriteBoardRepository writeBoardRepository;

  WriteBoardUseCase({required this.writeBoardRepository});

  Future<void> execute(
    String title,
    String content,
    String category,
    XFile? image,
  ) async {
    await writeBoardRepository.writeBoard(title, content, category, image);
  }
}
