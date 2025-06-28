import 'package:image_picker/image_picker.dart';

abstract interface class WriteBoardRepository {
  Future<void> writeBoard(
    String title,
    String content,
    String category,
    XFile? image,
  );
}
