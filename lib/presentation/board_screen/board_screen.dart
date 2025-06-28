import 'package:flutter/material.dart';
import 'package:front_mission/core/di/di_setup.dart'; // DI 설정을 위해 필요
import 'package:front_mission/presentation/board_screen/board_screen_view_model.dart';
import 'package:front_mission/presentation/write_borad_screen/write_board_screen.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  final BoardScreenViewModel viewModel;

  const BoardScreen({super.key, required this.viewModel});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchBoards();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ ChangeNotifierProvider를 사용하여 ViewModel을 위젯 트리에 제공 ⭐
    return ChangeNotifierProvider<BoardScreenViewModel>.value(
      value: widget.viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('게시판'), centerTitle: true),
        body: Consumer<BoardScreenViewModel>(
          // ⭐ Consumer를 사용하여 ViewModel의 상태 변화를 구독 ⭐
          builder: (context, viewModel, child) {
            // 로딩 상태에 따라 UI 표시
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text('에러: ${viewModel.errorMessage}'));
            } else if (viewModel.boards.isNotEmpty) {
              // 데이터가 성공적으로 로드되고 비어있지 않은 경우
              return ListView.builder(
                itemCount: viewModel.boards.length,
                itemBuilder: (context, index) {
                  final board = viewModel.boards[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            board.title ?? '제목 없음', // ⭐ 제목만 우선적으로 표시 ⭐
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              // 데이터가 비어 있는 경우
              return const Center(child: Text('게시글이 없습니다.'));
            }
          },
        ),
        // 게시글 작성 버튼
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // WriteBoardScreen으로 이동하고, 게시글 작성 성공 시 목록 새로고침
            final success = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteBoardScreen(viewModel: getIt()),
              ),
            );
            if (success != null && success) {
              widget.viewModel.fetchBoards(); // ⭐ ViewModel의 메서드 호출로 변경 ⭐
            }
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.mode_edit_outline_sharp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
