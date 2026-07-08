import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<CourseModel>> getCourses() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load courses");
    }
  }

  Future<void> addCourse(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({"title": title, "body": "new course", "userId": 1}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add course");
    }
  }

  Future<void> updateCourse(int id, String title) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      body: jsonEncode({
        "id": id,
        "title": title,
        "body": "updated course",
        "userId": 1,
      }),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update course");
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete course");
    }
  }
}
