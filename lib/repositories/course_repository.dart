import '../services/course_service.dart';
import '../services/local_storage_service.dart';
import '../services/connectivity_service.dart';
import '../models/course_model.dart';

/// Repository Pattern:
/// UI → Provider → Repository → CourseService (API) | LocalStorageService (Hive)
class CourseRepository {
  final CourseService _api = CourseService();
  final LocalStorageService _local = LocalStorageService();

  /// Fetch courses: tries API first, falls back to local cache if offline
  Future<List<CourseModel>> getCourses() async {
    final online = await ConnectivityService.isOnline();

    if (online) {
      try {
        final apiData = await _api.getCourses();
        // Sync local cache with fresh API data
        _local.saveCourses(apiData.map((e) => e.toJson()).toList());
        return apiData;
      } catch (e) {
        // API failed even online — try local cache
        return _loadFromLocal();
      }
    } else {
      // Offline — load from Hive
      return _loadFromLocal();
    }
  }

  List<CourseModel> _loadFromLocal() {
    final localData = _local.getCourses();
    return localData.map((e) => CourseModel.fromJson(e)).toList();
  }

  Future<void> addCourse(String title) => _api.addCourse(title);

  Future<void> updateCourse(int id, String title) =>
      _api.updateCourse(id, title);

  Future<void> deleteCourse(int id) => _api.deleteCourse(id);
}
