import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'author.dart';

class SelectAuthorListPage extends StatefulWidget {
  final Function(Author?) onAuthorSelected;
  final List<Author> authors;

  SelectAuthorListPage({
    required this.onAuthorSelected,
    required this.authors,
  });

  @override
  _SelectAuthorListPageState createState() => _SelectAuthorListPageState();
}

class _SelectAuthorListPageState extends State<SelectAuthorListPage> {
  List<Author> _authors = [];
  Author? _selectedAuthor;

  @override
  void initState() {
    super.initState();
    _authors = widget.authors;
    _fetchAuthors();
  }

  Future<void> _fetchAuthors() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/getAuthors'),
        headers: {
          'Authorization': 'Basic dGVzdDoxMjM0NTY=',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        _authors = jsonResponse.map((item) => Author.fromJson(item)).toList();
        setState(() {});
      } else {
        throw Exception('Failed to load authors');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Author')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Author>(
              hint: Text("Select an author"),
              value: _selectedAuthor,
              items: _authors.map((Author author) {
                return DropdownMenuItem<Author>(
                  value: author,
                  child: Text("${author.firstName} ${author.lastName}"),
                );
              }).toList(),
              onChanged: (Author? selectedAuthor) {
                setState(() {
                  _selectedAuthor = selectedAuthor;
                });
                widget.onAuthorSelected(selectedAuthor);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onAuthorSelected(_selectedAuthor);
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
