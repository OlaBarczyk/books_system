import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'publisher.dart';

class SelectPublisherListPage extends StatefulWidget {
  final Function(Publisher?) onPublisherSelected;
  final List<Publisher> publishers;

  SelectPublisherListPage({
    required this.onPublisherSelected,
    required this.publishers,
  });

  @override
  _SelectPublisherListPageState createState() => _SelectPublisherListPageState();
}

class _SelectPublisherListPageState extends State<SelectPublisherListPage> {
  List<Publisher> _publishers = [];
  Publisher? _selectedPublisher;

  @override
  void initState() {
    super.initState();
    _publishers = widget.publishers;
    _fetchPublishers();
  }

  Future<void> _fetchPublishers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/getPublishers'),
        headers: {
          'Authorization': 'Basic dGVzdDoxMjM0NTY=',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        _publishers = jsonResponse.map((item) => Publisher.fromJson(item)).toList();
        setState(() {});
      } else {
        throw Exception('Failed to load publishers');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Publisher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Publisher>(
              hint: Text("Select a publisher"),
              value: _selectedPublisher,
              items: _publishers.map((Publisher publisher) {
                return DropdownMenuItem<Publisher>(
                  value: publisher,
                  child: Text("${publisher.name}"),
                );
              }).toList(),
              onChanged: (Publisher? selectedPublisher) {
                setState(() {
                  _selectedPublisher = selectedPublisher;
                });
                widget.onPublisherSelected(selectedPublisher);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onPublisherSelected(_selectedPublisher);
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
