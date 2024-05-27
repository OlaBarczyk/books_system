import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';


class Book {
 final int id;
 final String title;
 final Author author;
 final Publisher publisher;
 final Genre genre;
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
      author: Author.fromJson(json['author']),
      publisher: Publisher.fromJson(json['publisher']),
      genre: Genre.fromJson(json['genre']),
      isbn: json['isbn'],
      numberOfPages: json['number_of_pages'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author.toJson(),
      'publisher': publisher.toJson(),
      'genre': genre.toJson(),
      'isbn': isbn,
      'number_of_pages': numberOfPages,
    };
 }
}
