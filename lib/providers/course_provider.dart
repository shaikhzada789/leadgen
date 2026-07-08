import 'package:flutter/material.dart';
import '../repositories/course_repository.dart';
import '../models/course_model.dart';

enum CourseState { initial, loading, success, error, empty }

class CourseProvider extends ChangeNotifier {
  final CourseRepository _repo = CourseRepository();

  List<CourseModel> _allCourses = [];
  List<CourseModel> courses = [];

  CourseState state = CourseState.initial;
  String error = '';
  String _searchQuery = '';
  bool isOffline = false;

  String get searchQuery => _searchQuery;

  // ─── Fetch Courses ────────────────────────────────────────────────────────
  Future<void> fetchCourses() async {
    state = CourseState.loading;
    notifyListeners();

    try {
      _allCourses = await _repo.getCourses();
      error = '';
      _applySearch();

      state = courses.isEmpty ? CourseState.empty : CourseState.success;
    } catch (e) {
      error = e.toString();
      state = CourseState.error;
    }

    notifyListeners();
  }

  // ─── Delete with Optimistic UI ────────────────────────────────────────────
  Future<void> deleteCourse(int id) async {
    final oldAll = List<CourseModel>.from(_allCourses);
    final oldFiltered = List<CourseModel>.from(courses);

    // Optimistic: remove immediately from UI
    _allCourses.removeWhere((c) => c.id == id);
    courses.removeWhere((c) => c.id == id);

    if (courses.isEmpty) {
      state = CourseState.empty;
    }
    notifyListeners();

    try {
      await _repo.deleteCourse(id);
    } catch (e) {
      // Rollback on failure
      _allCourses = oldAll;
      courses = oldFiltered;
      state = CourseState.success;
      error = 'Delete failed. Changes reverted.';
      notifyListeners();
    }
  }

  // ─── Update with Optimistic UI ────────────────────────────────────────────
  Future<void> updateCourse(int id, String newTitle) async {
    final oldAll = List<CourseModel>.from(_allCourses);
    final oldFiltered = List<CourseModel>.from(courses);

    // Optimistic update
    _allCourses = _allCourses.map((c) {
      if (c.id == id) return CourseModel(id: c.id, title: newTitle, body: c.body);
      return c;
    }).toList();
    _applySearch();
    notifyListeners();

    try {
      await _repo.updateCourse(id, newTitle);
    } catch (e) {
      // Rollback
      _allCourses = oldAll;
      courses = oldFiltered;
      error = 'Update failed. Changes reverted.';
      notifyListeners();
    }
  }

  // ─── Add Course ───────────────────────────────────────────────────────────
  Future<void> addCourse(String title) async {
    await _repo.addCourse(title);
    await fetchCourses();
  }

  // ─── Search / Filter ──────────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    _applySearch();
    state = courses.isEmpty ? CourseState.empty : CourseState.success;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applySearch();
    state = courses.isEmpty ? CourseState.empty : CourseState.success;
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      courses = List.from(_allCourses);
    } else {
      courses = _allCourses
          .where((c) =>
              c.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}
