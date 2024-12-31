import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/phone_view_model.dart';
import '../Model/Home.dart';

class ContactView extends StatefulWidget {
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ContactViewModel>(context);

    // 연락처 데이터 정렬 및 필터링
    final filteredContacts = viewModel.contacts
      ..sort((a, b) => a.name.compareTo(b.name));
    final displayedContacts = filteredContacts
        .where((contact) => contact.name.contains(_searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '연락처',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedContacts.length,
              itemBuilder: (context, index) {
                final contact = displayedContacts[index];
                return GestureDetector(
                  onTap: () => _showContactDetailsDialog(context, viewModel, contact),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    leading: Text(
                      contact.name,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      contact.phone,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context, viewModel),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // 연락처 상세 팝업
  void _showContactDetailsDialog(
      BuildContext context, ContactViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연락처 상세'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('이름: ${contact.name}'),
              SizedBox(height: 10),
              Text('전화번호: ${contact.phone}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 기존 팝업 닫기
                _showEditContactDialog(context, viewModel, contact);
              },
              child: Text('수정'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 기존 팝업 닫기
                viewModel.deleteContact(contact);
              },
              child: Text('삭제'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

// 연락처 수정 팝업
  void _showEditContactDialog(
      BuildContext context, ContactViewModel viewModel, Contact contact) {
    final TextEditingController nameController =
    TextEditingController(text: contact.name);
    final TextEditingController phoneController =
    TextEditingController(text: contact.phone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연락처 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: '이름'),
                controller: nameController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(hintText: '전화번호'),
                keyboardType: TextInputType.phone,
                controller: phoneController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 수정 팝업 닫기
                _showCancelConfirmationDialog(
                  context,
                  viewModel,
                  contact,
                  nameController.text,
                  phoneController.text,
                ); // 취소 확인 팝업 표시
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedContact = Contact(
                  name: nameController.text,
                  phone: phoneController.text,
                );
                viewModel.updateContact(contact, updatedContact);
                Navigator.pop(context); // 수정 팝업 닫기
              },
              child: Text('적용'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelConfirmationDialog(
      BuildContext context,
      ContactViewModel viewModel,
      Contact contact,
      String currentName,
      String currentPhone,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수정 취소'),
          content: Text('취소하시겠습니까? 현재 수정 내용이 저장되지 않습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 취소 확인 팝업 닫기
                _showEditContactDialogWithState(
                  context,
                  viewModel,
                  contact,
                  currentName,
                  currentPhone,
                ); // 수정 팝업 다시 열기 (수정하던 내용 유지)
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 취소 확인 팝업 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showEditContactDialogWithState(
      BuildContext context,
      ContactViewModel viewModel,
      Contact contact,
      String currentName,
      String currentPhone,
      ) {
    final TextEditingController nameController =
    TextEditingController(text: currentName);
    final TextEditingController phoneController =
    TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연락처 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: '이름'),
                controller: nameController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(hintText: '전화번호'),
                keyboardType: TextInputType.phone,
                controller: phoneController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 수정 팝업 닫기
                _showCancelConfirmationDialog(
                  context,
                  viewModel,
                  contact,
                  nameController.text,
                  phoneController.text,
                ); // 취소 확인 팝업 표시
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedContact = Contact(
                  name: nameController.text,
                  phone: phoneController.text,
                );
                viewModel.updateContact(contact, updatedContact);
                Navigator.pop(context); // 수정 팝업 닫기
              },
              child: Text('적용'),
            ),
          ],
        );
      },
    );
  }



  // 새 연락처 추가 팝업
  void _showAddContactDialog(BuildContext context, ContactViewModel viewModel) {
    String name = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새 연락처 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: '이름'),
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(hintText: '전화번호'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  phone = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && phone.isNotEmpty) {
                  final newContact = Contact(name: name, phone: phone);
                  viewModel.addContact(newContact);
                  Navigator.pop(context);
                }
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }
}