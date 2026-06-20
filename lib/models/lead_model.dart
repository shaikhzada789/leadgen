// lib/models/lead_model.dart
import 'package:uuid/uuid.dart';

enum LeadStatus {
  newContact,
  negotiating,
  pendingVerify,
  closedWon,
  closedLost,
}

enum UserRole { salesAgent, salesManager, executive }

extension LeadStatusExt on LeadStatus {
  String get label {
    switch (this) {
      case LeadStatus.newContact: return 'New Contact';
      case LeadStatus.negotiating: return 'Negotiating';
      case LeadStatus.pendingVerify: return 'Pending Verify';
      case LeadStatus.closedWon: return 'Closed Won';
      case LeadStatus.closedLost: return 'Closed Lost';
    }
  }

  String get colorHex {
    switch (this) {
      case LeadStatus.newContact: return '3B82F6';
      case LeadStatus.negotiating: return 'F59E0B';
      case LeadStatus.pendingVerify: return 'A855F7';
      case LeadStatus.closedWon: return '10B981';
      case LeadStatus.closedLost: return 'F43F5E';
    }
  }
}

class AuditLog {
  final String action;
  final String userId;
  final DateTime timestamp;
  final String status;

  AuditLog({
    required this.action,
    required this.userId,
    required this.timestamp,
    required this.status,
  });
}

class Lead {
  final String id;
  String companyName;
  double estimatedValue;
  String source;
  LeadStatus status;
  String assignedTo;
  DateTime createdAt;
  DateTime updatedAt;
  List<AuditLog> auditLogs;
  bool hasDocument;
  String? contactPerson;
  String? email;
  String? phone;
  String? notes;

  Lead({
    String? id,
    required this.companyName,
    required this.estimatedValue,
    required this.source,
    this.status = LeadStatus.newContact,
    required this.assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AuditLog>? auditLogs,
    this.hasDocument = false,
    this.contactPerson,
    this.email,
    this.phone,
    this.notes,
  })  : id = id ?? 'L-${const Uuid().v4().substring(0, 6).toUpperCase()}',
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        auditLogs = auditLogs ?? [];

  void addLog(String action, String userId, String logStatus) {
    auditLogs.add(AuditLog(
      action: action,
      userId: userId,
      timestamp: DateTime.now(),
      status: logStatus,
    ));
    updatedAt = DateTime.now();
  }
}

class AppUser {
  final String id;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.role,
  });

  String get roleLabel {
    switch (role) {
      case UserRole.salesAgent: return 'Sales Agent';
      case UserRole.salesManager: return 'Sales Manager';
      case UserRole.executive: return 'Executive';
    }
  }
}
