import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Genre {
 final int id;
 final String name;

 Genre({
    required this.id,
    required this.name
 });

 factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
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

 static Future<List<Genre>> getGenres() async {
    final url = Uri.parse('http://localhost:8080/getGenres');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      return responseData.map((data) => Genre.fromJson(data)).toList();
    } else {
      throw Exception('Error retrieving genres');
    }
 }

 static Future<Genre> getGenreByName(String name) async {
    final url = Uri.parse('http://localhost:8080/getGenres');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final genres = responseData.map((data) => Genre.fromJson(data)).toList();

      final genre = genres.firstWhere(
        (genre) => genre.name.toLowerCase() == name.toLowerCase(),
        orElse: () => Genre.fromJson({}), 
      );

      if (genre != null) {
        return genre;
      } else {
        throw Exception('Genre not found');
      }
    } else {
      throw Exception('Error retrieving genres');
    }
 }

 Future<void> addGenre() async {
    final url = Uri.parse('http://localhost:8080/addGenre');
    final name = this.name;
    final body = jsonEncode({
      'name': name,
    });

    try {
      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Genre added successfully!');
      } else {
        throw Exception('Error adding genre!');
      }
    } on Exception catch (e) {
      throw Exception('An error occured: $e');
    }
 }

 Future<void> updateGenre() async {
    final url = Uri.parse('http://localhost:8080/updateGenre');
    final body = jsonEncode(this);

    try {
      final response = await http.put(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Genre updated successfully!');
      } else {
        throw Exception('Error updating genre!');
      }
    } on Exception catch (e) {
      throw Exception('An error occured: $e');
    }
 }

Future<void> deleteGenre(int id) async {
  final url = Uri.parse('http://localhost:8080/deleteGenre/$id');

  try {
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print('Genre removed successfully!');
    } else {
      throw Exception('Error removing genre!');
    }
  } on Exception catch (e) {
    throw Exception('An error occurred: $e');
  }
}

}
