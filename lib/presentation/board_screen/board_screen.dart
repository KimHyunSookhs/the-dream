import 'package:flutter/material.dart';
import 'package:front_mission/core/di/di_setup.dart'; // DI 설정을 위해 필요
import 'package:front_mission/data/model/user_info.dart';
import 'package:front_mission/presentation/board_screen/board_screen_view_model.dart';
import 'package:front_mission/presentation/write_borad_screen/write_board_screen.dart';
import 'package:provider/provider.dart';

import '../../core/token_manager.dart';
import '../detail_screen/detail_board_screen.dart';

class BoardScreen extends StatefulWidget {
  final BoardScreenViewModel viewModel;

  const BoardScreen({super.key, required this.viewModel});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late final ScrollController _scrollController;
  UserInfo? user;

  @override
  void initState() {
    super.initState();
    _loadUserFromToken();
    widget.viewModel.fetchBoards();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      widget.viewModel.fetchBoards();
    }
  }

  Future<void> _loadUserFromToken() async {
    final tokenManager = getIt<TokenManager>();
    final userInfo = await tokenManager.getUserFromToken();
    if (userInfo != null) {
      setState(() {
        user = userInfo;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BoardScreenViewModel>.value(
      value: widget.viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('게시판'),
          centerTitle: true,
          actions: user != null
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user!.username ?? '없음',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          user!.name ?? '없음',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ]
              : [],
        ),
        body: Consumer<BoardScreenViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.boards.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text('에러: ${viewModel.errorMessage}'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.boards.length,
                      itemBuilder: (context, index) {
                        final board = viewModel.boards[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailBoardScreen(
                                  viewModel: getIt(),
                                  id: board.id!,
                                ),
                              ),
                            );
                            if (result == true) {
                              await widget.viewModel.fetchBoards(
                                page: viewModel.currentPage,
                              );
                            }
                          },
                          child: Card(
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
                                    board.title ?? '제목 없음',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔽 페이지네이션 버튼 영역
                  if (viewModel.totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: viewModel.currentPage > 0
                                ? () {
                                    viewModel.fetchBoards(
                                      page: viewModel.currentPage - 1,
                                    );
                                  }
                                : null,
                          ),
                          ...List.generate(viewModel.totalPages, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      viewModel.currentPage == index
                                      ? Colors.blueAccent
                                      : Colors.grey[300],
                                ),
                                onPressed: () {
                                  viewModel.fetchBoards(page: index);
                                },
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: viewModel.currentPage == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed:
                                viewModel.currentPage < viewModel.totalPages - 1
                                ? () {
                                    viewModel.fetchBoards(
                                      page: viewModel.currentPage + 1,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final success = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteBoardScreen(viewModel: getIt()),
              ),
            );
            if (success != null && success) {
              widget.viewModel.fetchBoards(page: widget.viewModel.currentPage);
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
