import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/message_view_model.dart';

class CommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commentViewModel = Provider.of<CommentViewModel>(context);

    TextEditingController _commentController = TextEditingController();

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
                      hintText: 'Message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final newComment = _commentController.text.trim();
                    if (newComment.isNotEmpty) {
                      commentViewModel.addComment(newComment, "임진석"); // '임진석'으로 댓글 추가
                      _commentController.clear(); // 입력창 초기화
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
