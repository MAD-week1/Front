import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ChangeNotifierProvider 가져오기
import '../ViewModel/Home_view_model.dart';
import '../Model/Home.dart';

class HomeView extends StatelessWidget {
  final String sampleJson = '''
  [
    {"name": "John Doe", "phone": "010-1234-5678"},
    {"name": "Jane Doe", "phone": "010-9876-5432"},
    {"name": "Alice", "phone": "010-1111-2222"},
    {"name": "Bob", "phone": "010-3333-4444"}
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadContacts(sampleJson), // ViewModel 초기화
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('연락처'),
          centerTitle: true,
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.contacts.length,
              itemBuilder: (context, index) {
                final contact = viewModel.contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(contact.name[0]), // 이름의 첫 글자 표시
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                );
              },
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
