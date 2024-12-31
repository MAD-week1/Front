import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/phone_view_model.dart';

class ContactView extends StatefulWidget {
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ContactViewModel>(context);

    // 연락처 데이터를 ABC/가나다 순으로 정렬 및 검색어에 따라 필터링
    final filteredContacts = viewModel.contacts
      ..sort((a, b) => a.name.compareTo(b.name));
    final displayedContacts = filteredContacts
        .where((contact) => contact.name.contains(_searchQuery))
        .toList();

    return Scaffold(
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
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contact.phone,
                        style:
                        TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
