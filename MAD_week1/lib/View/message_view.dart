import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/message_view_model.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentViewModel = Provider.of<CommentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('게시판', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CommentViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.comments.isEmpty) {
                  return Center(
                    child: Text(
                      "등록된 댓글이 없습니다.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: viewModel.comments.length,
                  itemBuilder: (context, index) {
                    final comment = viewModel.comments[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${comment.author}: ${comment.content}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${comment.timestamp.hour}:${comment.timestamp.minute} 작성',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Divider(height: 20, color: Colors.grey[300]),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newComment = _commentController.text.trim();
                    if (newComment.isNotEmpty) {
                      final result = await commentViewModel.addComment(newComment, "임진석");
                      if (!result) {
                        // 스팸 메시지일 경우 경고 팝업 표시
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("경고"),
                            content: Text("스팸 메시지가 감지되었습니다."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("확인"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        _commentController.clear(); // 입력창 초기화
                      }
                    }
                  },
                  child: Text('전송'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
