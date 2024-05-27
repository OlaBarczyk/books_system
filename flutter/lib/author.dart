import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Author {
 final int id;
 final String firstName;
 final String lastName;

 Author({
    required this.id,
    required this.firstName,
    required this.lastName,
 });

 factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
 }

 static Future<List<Author>> getAuthors() async {
    final url = Uri.parse('http://localhost:8080/getAuthors');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      return responseData.map((data) => Author.fromJson(data)).toList();
    } else {
      throw Exception('Error retrieving authors');
    }
 }

 static Future<Author> getAuthorByName(String name) async {
    final url = Uri.parse('http://localhost:8080/getAuthors');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final authors = responseData.map((data) => Author.fromJson(data)).toList();

      final author = authors.firstWhere(
        (author) => author.firstName.toLowerCase() == name.toLowerCase() || author.lastName.toLowerCase() == name.toLowerCase(),
        orElse: () => Author.fromJson({}),
      );

      if (author != null) {
        return author;
      } else {
        throw Exception('Author not found');
      }
    } else {
      throw Exception('Error retrieving authors');
    }
 }

 static Future<void> addAuthor(String firstName, String lastName) async {
    final url = Uri.parse('http://localhost:8080/addAuthor');
    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
    });

    try {
      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        print('Author added successfully!');
      } else {
        throw Exception('Error adding author!');
      }
    } on Exception catch (e) {
      throw Exception('An error occured: $e');
    }
 }

 Future<void> updateAuthor() async {
    final url = Uri.parse('http://localhost:8080/updateAuthor');
    final body = jsonEncode(this);

    try {
      final response = await http.put(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Author updated successfully!');
      } else {
        throw Exception('Error updating author!');
      }
    } on Exception catch (e) {
      throw Exception('An error occured: $e');
    }
 }

 static Future<void> deleteAuthor(int id) async {
 final url = Uri.parse('http://localhost:8080/deleteAuthor/$id');
 final response = await http.delete(url);

 if (response.statusCode == 200) {
    print('Author deleted successfully');
 } else {
    throw Exception('Failed to delete author');
 }
}

}
