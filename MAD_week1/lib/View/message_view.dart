import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../ViewModel/message_view_model.dart';

class SpamFilterPage extends StatefulWidget {
  @override
  _SpamFilterPageState createState() => _SpamFilterPageState();
}

class _SpamFilterPageState extends State<SpamFilterPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spamFilterViewModel = Provider.of<SpamFilterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('스팸 필터', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('스팸 메시지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: spamFilterViewModel.spamMessages.length,
                          itemBuilder: (context, index) {
                            final message = spamFilterViewModel.spamMessages[index];
                            return ListTile(
                              title: Text(message, style: TextStyle(fontSize: 15),),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      Text('정상 메시지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: spamFilterViewModel.nonSpamMessages.length,
                          itemBuilder: (context, index) {
                            final message = spamFilterViewModel.nonSpamMessages[index];
                            return GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: message));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('복사되었습니다.')),);
                              },
                              child: ListTile(
                                title: Text(message, style: TextStyle(fontSize: 15),),
                              ),
                            );

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
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
                    final inputText = _textController.text.trim();
                    if (inputText.isNotEmpty) {
                      final isSpam = await spamFilterViewModel.checkSpam(inputText);
                      if (isSpam != null) {
                        _textController.clear();
                      }
                    }
                  },
                  child: Text('검사'),
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
