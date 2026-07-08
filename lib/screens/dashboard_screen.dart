import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../controllers/auth_controller.dart';
import '../services/connectivity_service.dart';
import 'login_screen.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';
import '../models/course_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _isOnline = await ConnectivityService.isOnline();
      if (mounted) setState(() {});
      if (mounted) context.read<CourseProvider>().fetchCourses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final user = AuthController.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Hi, ${user?.name ?? 'User'} 👋",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Offline Banner ───────────────────────────────────────────────
          if (!_isOnline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade700,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "You're offline — showing cached data",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),

          // ── Error Banner ─────────────────────────────────────────────────
          if (provider.error.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.red.shade100,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                provider.error,
                style: TextStyle(color: Colors.red.shade800, fontSize: 13),
              ),
            ),

          // ── Search Bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => provider.search(v),
              decoration: InputDecoration(
                hintText: "Search courses...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Course Count ─────────────────────────────────────────────────
          if (provider.state == CourseState.success)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    "${provider.courses.length} course(s) found",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(child: _buildBody(provider)),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Course", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCourseScreen()),
          );
          if (result == true && mounted) {
            provider.fetchCourses();
          }
        },
      ),
    );
  }

  Widget _buildBody(CourseProvider provider) {
    switch (provider.state) {
      case CourseState.loading:
      case CourseState.initial:
        return const Center(child: CircularProgressIndicator());

      case CourseState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 12),
              Text(provider.error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.fetchCourses,
                child: const Text("Retry"),
              ),
            ],
          ),
        );

      case CourseState.empty:
        return RefreshIndicator(
          onRefresh: provider.fetchCourses,
          child: ListView(
            children: const [
              SizedBox(height: 160),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 72, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      "No courses found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      "Pull down to refresh or add one",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case CourseState.success:
        return RefreshIndicator(
          onRefresh: () async {
            _isOnline = await ConnectivityService.isOnline();
            setState(() {});
            await provider.fetchCourses();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 90),
            itemCount: provider.courses.length,
            itemBuilder: (context, index) {
              final course = provider.courses[index];
              return _CourseCard(course: course, provider: provider);
            },
          ),
        );
    }
  }
}

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final CourseProvider provider;

  const _CourseCard({required this.course, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            course.title.isNotEmpty ? course.title[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text("ID: ${course.id}",
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              tooltip: "Edit",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditCourseScreen(course: course)),
                );
                if (result == true) {
                  // provider already updated optimistically
                }
              },
            ),
            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: "Delete",
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Course"),
        content: Text('Delete "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteCourse(course.id);
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
