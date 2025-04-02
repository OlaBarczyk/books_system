import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Publisher {
 final int id;
 final String name;

 Publisher({
    required this.id,
    required this.name,
  });

 factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'],
      name: json['name'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
 }

 static Future<List<Publisher>> getPublishers() async {
    final url = Uri.parse('http://localhost:8080/getPublishers');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      return responseData.map((data) => Publisher.fromJson(data)).toList();
    } else {
      throw Exception('Error retrieving authors');
    }
 }

 static Future<Publisher> getPublisherByName(String name) async {
    final url = Uri.parse('http://localhost:8080/getPublishers');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final publishers = responseData.map((data) => Publisher.fromJson(data)).toList();

      final publisher = publishers.firstWhere(
        (publisher) => publisher.name.toLowerCase() == name.toLowerCase(),
        orElse: () => Publisher.fromJson({}),
      );

      if (publisher != null) {
        return publisher;
      } else {
        throw Exception('Publisher not found');
      }
    } else {
      throw Exception('Error retrieving publishers');
    }
 }

 static Future<void> addPublisher(String name) async {
    final url = Uri.parse('http://localhost:8080/addPublisher');
    final body = jsonEncode({
      'name': name,
    });

    try {
      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        print('Publisher added successfully!');
      } else {
        throw Exception('Error adding publisher!');
      }
    } on Exception catch (e) {
      throw Exception('An error occured: $e');
    }
 }

 Future<void> updatePublisher() async {
    final url = Uri.parse('http://localhost:8080/updatePublisher');
    final body = jsonEncode(this);

    try {
      final response = await http.put(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Publisher updated successfully!');
      } else {
        throw Exception('Error updating publisher!');
      }
    } on Exception catch (e) {
      throw Exception('An publisher occured: $e');
    }
 }

 static Future<void> deletePublisher(int id) async {
 final url = Uri.parse('http://localhost:8080/deletePublisher/$id');
 final response = await http.delete(url);

 if (response.statusCode == 200) {
    print('Publisher deleted successfully');
 } else {
    throw Exception('Failed to delete publisher');
 }
}

}
