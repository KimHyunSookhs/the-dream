import 'package:flutter/material.dart';
import 'package:front_mission/presentation/detail_screen/detail_board_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/di/di_setup.dart';
import '../../data/model/detail_board.dart';
import '../board_screen/board_screen.dart';
import '../patch_board_screen/patch_board_screen.dart';

class DetailBoardScreen extends StatefulWidget {
  final DetailBoardViewModel viewModel;
  final int id;

  const DetailBoardScreen({
    super.key,
    required this.viewModel,
    required this.id,
  });

  @override
  State<DetailBoardScreen> createState() => _DetailBoardScreenState();
}

class _DetailBoardScreenState extends State<DetailBoardScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchBoard(widget.id);
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr; // 실패 시 원본 출력
    }
  }

  Future<void> confirmDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시글 삭제'),
          content: Text('정말로 이 게시글을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () async {
                await widget.viewModel.deleteBoard(widget.id);
                setState(() {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => BoardScreen(viewModel: getIt()),
                    ),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailBoardViewModel>.value(
      value: widget.viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('게시글 상세'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                confirmDelete();
              },
            ),
            SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatchBoardScreen(
                      viewModel: widget.viewModel,
                      board: widget.viewModel.board!,
                    ),
                  ),
                );
                if (result == true) {
                  await widget.viewModel.fetchBoard(widget.id);
                  setState(() {});
                }
              },
            ),
          ],
        ),
        body: Consumer<DetailBoardViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text('에러: ${viewModel.errorMessage}'));
            } else if (viewModel.board != null) {
              final DetailBoard board = viewModel.board!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      board.title ?? '제목 없음',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '카테고리: ${board.boardCategory ?? '없음'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    if (board.imageUrl != null)
                      Image.network(
                        'https://front-mission.bigs.or.kr${board.imageUrl}',
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      board.content ?? '내용 없음',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '작성일: ${_formatDateTime(board.createdAt)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('게시글을 불러올 수 없습니다.'));
            }
          },
        ),
      ),
    );
  }
}
