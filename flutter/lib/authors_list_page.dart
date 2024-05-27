import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'author.dart';
import 'add_author_page.dart';
import 'update_author_page.dart';
import 'delete_author_page.dart';

class AuthorsListPage extends StatefulWidget {
  final Function refreshAuthorsList;
  AuthorsListPage ({required this.refreshAuthorsList});
  
  @override
  _AuthorsListPageState createState() => _AuthorsListPageState();
}

class _AuthorsListPageState extends State<AuthorsListPage> {
  Future<List<Author>>? _authorsFuture;
  List<Author> _authors = [];
  bool _isAuthorsListEmpty = true;
  Author? _selectedAuthor;

  @override
  void initState() {
    super.initState();
    widget.refreshAuthorsList();
    _fetchAuthors();
  }

 void _fetchAuthors() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080/getAuthors'), 
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      },
    );

    switch (response.statusCode) {
      case 200:
        setState(() {
          _authors = (json.decode(response.body) as List)
            .map((data) => Author.fromJson(data))
            .toList();
          _isAuthorsListEmpty = _authors.isEmpty;
        });
        break;
      case 400:
        print('Bad request: ${response.body}');
        break;
      case 403:
        print('Forbidden: ${response.body}');
        break;
      case 500:
        print('Internal server error: ${response.body}');
        break;
      default:
        print('Unexpected status code: ${response.statusCode}');
        break;
    }
  } catch (error) {
    print('Fetch failed: $error');
  }
}

  void refreshAuthorsList() {
    setState(() {
      _fetchAuthors();
      _isAuthorsListEmpty = _authors.isEmpty;
    });
  }

  List<Widget> _buildAuthorList(List<Author> authors) {
    if (authors.isEmpty) {
      return [Text('No authors added yet.')];
    } else {
      return authors.map((author) => ListTile(
            title: Text('${author.firstName} ${author.lastName}'),
            subtitle: Text('Author'),
            onTap: () {
              setState(() {
                _selectedAuthor = author;
              });
            },
          )).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.deepPurple, Colors.green],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(child: Text('Authors List')),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Author>>(
                    future: _authorsFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Author>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.hasData) {
                          _authors = snapshot.data!;
                          _isAuthorsListEmpty = _authors.isEmpty;
                        }
                        return _isAuthorsListEmpty
                          ? Center(child: Text('No authors added yet.'))
                           : ListView(children: _buildAuthorList(_authors));
                      }
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAuthorPage(
                              refreshAuthorsList: refreshAuthorsList,
                            ),
                          ),
                        );
                      },
                      child: Text('Add a new author'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedAuthor!= null)...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateAuthorPage(
                                author: _selectedAuthor!,
                                refreshAuthorsList: refreshAuthorsList,
                              ),
                            ),
                          );
                        },
                        child: Text('Edit Author'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAuthorPage(
                                author: _selectedAuthor!,
                                refreshAuthorsList: refreshAuthorsList,
                              ),
                            ),
                          ).then((_) {
                            refreshAuthorsList();
                          });
                        },
                        child: Text('Delete Author'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
