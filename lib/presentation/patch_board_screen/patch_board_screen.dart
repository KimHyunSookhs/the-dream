import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:front_mission/presentation/board_screen/board_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/di/di_setup.dart';
import '../../data/model/board.dart';
import '../../data/model/detail_board.dart';
import '../../presentation/detail_screen/detail_board_view_model.dart';

class PatchBoardScreen extends StatefulWidget {
  final DetailBoard board;
  final DetailBoardViewModel viewModel;

  const PatchBoardScreen({
    super.key,
    required this.board,
    required this.viewModel,
  });

  @override
  State<PatchBoardScreen> createState() => _PatchBoardScreenState();
}

class _PatchBoardScreenState extends State<PatchBoardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? _pickedImage;
  Uint8List? _imageBytes;

  final Map<String, String> _categoryMap = {
    "NOTICE": "공지",
    "FREE": "자유",
    "QNA": "Q&A",
    "ETC": "기타",
  };

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.board.title ?? '';
    _contentController.text = widget.board.content ?? '';
    _selectedCategory = _categoryMap[widget.board.boardCategory] ?? '공지';
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedImage = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글 수정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '제목',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '제목을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton(
              value: _selectedCategory,
              isExpanded: true,
              items: _categoryMap.values.map((label) {
                return DropdownMenuItem(value: label, child: Text(label));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            const Text('내용', style: TextStyle(fontSize: 20)),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: '내용을 입력해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: Icon(Icons.camera_alt),
            ),
            (_imageBytes != null)
                ? Image.memory(
                    _imageBytes!,
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                : (widget.board.imageUrl != null)
                ? Image.network(
                    'https://front-mission.bigs.or.kr${widget.board.imageUrl}',
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                : const Text('선택된 이미지가 없습니다.'),

            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: const Text('게시글을 수정하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('확인'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('취소'),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                final categoryKey = _categoryMap.entries
                    .firstWhere((e) => e.value == _selectedCategory)
                    .key;

                final success = await widget.viewModel.patchBoard(
                  widget.board.id!,
                  Board(
                    title: _titleController.text,
                    content: _contentController.text,
                    category: categoryKey,
                  ),
                  _pickedImage,
                );

                if (success.title != null) {
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => BoardScreen(viewModel: getIt()),
                    ),
                    (route) => false, // 모든 이전 스택 제거
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('게시글 수정에 실패했습니다.')),
                  );
                }
              },
              child: const Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
