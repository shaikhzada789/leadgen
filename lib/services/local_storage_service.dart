import 'package:hive/hive.dart';

class LocalStorageService {
  final box = Hive.box('coursesBox');

  void saveCourses(List<Map<String, dynamic>> courses) {
    box.put('courses', courses);
  }

  List<Map<String, dynamic>> getCourses() {
    final raw = box.get('courses', defaultValue: []);
    return List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  bool hasCourses() {
    final raw = box.get('courses');
    return raw != null && (raw as List).isNotEmpty;
  }

  void clear() {
    box.delete('courses');
  }
}
