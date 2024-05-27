import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'publisher.dart';
import 'add_publisher_page.dart';
import 'update_publisher_page.dart';
import 'delete_publisher_page.dart';

class PublishersListPage extends StatefulWidget {
  final Function refreshPublishersList;

  PublishersListPage({required this.refreshPublishersList});

  @override
  _PublishersListPageState createState() => _PublishersListPageState();
}

class _PublishersListPageState extends State<PublishersListPage> {
  Future<List<Publisher>>? _publishersFuture;
  List<Publisher> _publishers = [];
  bool _isPublishersListEmpty = true;
  Publisher? _selectedPublisher;

  @override
  void initState() {
    super.initState();
    _fetchPublishers();
  }

 void _fetchPublishers() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080/getPublishers'), 
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      },
    );

    switch (response.statusCode) {
      case 200:
        setState(() {
          _publishers = (json.decode(response.body) as List)
            .map((data) => Publisher.fromJson(data))
            .toList();
          _isPublishersListEmpty = _publishers.isEmpty;
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

  void refreshPublishersList() {
    setState(() {
      _fetchPublishers();
      _isPublishersListEmpty = _publishers.isEmpty;
    });
  }

  List<Widget> _buildPublisherList(List<Publisher> publishers) {
    if (publishers.isEmpty) {
      return [Text('No publishers added yet.')];
    } else {
      return publishers.map((publisher) => ListTile(
            title: Text('${publisher.name}'),
            subtitle: Text('Publisher'),
            onTap: () {
              setState(() {
                _selectedPublisher = publisher;
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
          title: Center(child: Text('Publishers List')),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Publisher>>(
                    future: _publishersFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Publisher>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.hasData) {
                          _publishers = snapshot.data!;
                          _isPublishersListEmpty = _publishers.isEmpty;
                        }
                        return _isPublishersListEmpty
                          ? Center(child: Text('No publishers added yet.'))
                           : ListView(children: _buildPublisherList(_publishers));
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
                            builder: (context) => AddPublisherPage(
                              refreshPublishersList: refreshPublishersList,
                            ),
                          ),
                        );
                      },
                      child: Text('Add a new publisher'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedPublisher!= null)...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePublisherPage(
                                publisher: _selectedPublisher!,
                                refreshPublishersList: refreshPublishersList,
                              ),
                            ),
                          );
                        },
                        child: Text('Edit Publisher'),
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
                              builder: (context) => DeletePublisherPage(
                                publisher: _selectedPublisher!,
                                refreshPublishersList: refreshPublishersList,
                              ),
                            ),
                          ).then((_) {
                            refreshPublishersList();
                          });
                        },
                        child: Text('Delete Publisher'),
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
