//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';


class Book {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String genre;
  final int isbn;
  final int numberOfPages;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.genre,
    required this.isbn,
    required this.numberOfPages,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: "${json['author']['firstName']} ${json['author']['lastName']}", 
      publisher: json['publisher']['name'],
      genre: json['genre']['name'],
      isbn: json['isbn'],
      numberOfPages: json['number_of_pages'],
    );
  }
}
