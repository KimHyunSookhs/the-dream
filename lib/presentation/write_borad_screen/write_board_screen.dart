import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_mission/presentation/write_borad_screen/write_board_view_model.dart';
import 'package:image_picker/image_picker.dart';

class WriteBoardScreen extends StatefulWidget {
  final WriteBoardViewModel viewModel;

  const WriteBoardScreen({super.key, required this.viewModel});

  @override
  State<WriteBoardScreen> createState() => _WriteBoardScreenState();
}

class _WriteBoardScreenState extends State<WriteBoardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _jwtToken;
  final picker = ImagePicker();
  XFile? _pickedImage;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadJwtTokenFromSecureStorage();
  }

  Future<void> _loadJwtTokenFromSecureStorage() async {
    try {
      final token = await _secureStorage.read(key: 'jwtToken');
      setState(() {
        _jwtToken = token;
      });
      widget.viewModel.setJwtToken(token!);
      if (token == null) {
        print('게시글 작성 화면: Secure Storage에 JWT 토큰이 없습니다.');
      } else {
        print('게시글 작성 화면: Secure Storage에서 JWT 토큰 불러오기 성공.');
      }
    } catch (e) {
      print('Secure Storage에서 JWT 토큰 불러오기 오류: $e');
    }
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
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('글쓰기')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '제목',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력해주세요',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              Text(
                '카테고리',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: '카테고리를 입력해주세요',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text('내용', style: TextStyle(fontSize: 20)),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                maxLines: 6,
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Icon(Icons.camera_alt),
              ),
              _imageBytes == null
                  ? Text('선택된 이미지가 없습니다.')
                  : Image.memory(
                      _imageBytes!,
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                '게시글을 올리시겠습니까?',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                              String title = _titleController.text;
                              String content = _contentController.text;
                              String category = _categoryController.text;
                              widget.viewModel.writeBoard(
                                title,
                                content,
                                category,
                                _pickedImage,
                              );
                            },
                            child: Text(
                              '완료',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('등록', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
