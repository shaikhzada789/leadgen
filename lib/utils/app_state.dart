// lib/utils/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/lead_model.dart';

class AppState extends ChangeNotifier {
  AppUser? currentUser;
  List<Lead> leads = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void login(AppUser user) {
    currentUser = user;
    _seedDemoData();
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    leads = [];
    notifyListeners();
  }

  void _seedDemoData() {
    final now = DateTime.now();
    leads = [
      Lead(
        id: 'L-101',
        companyName: 'Acme Corp',
        estimatedValue: 45000,
        source: 'Web Inquiry',
        status: LeadStatus.closedWon,
        assignedTo: 'Daniyal',
        createdAt: now.subtract(const Duration(days: 5)),
        hasDocument: true,
        contactPerson: 'John Smith',
        email: 'john@acmecorp.com',
        phone: '+1-555-0101',
      )..auditLogs.addAll([
          AuditLog(action: 'Lead Created', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 5)), status: 'SUCCESS'),
          AuditLog(action: 'Log Call', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 4)), status: 'SUCCESS'),
          AuditLog(action: 'ATTEMPT_CLOSE', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 3)), status: 'BLOCKED_TR09'),
          AuditLog(action: 'UPLOAD_DOC', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 2)), status: 'QUEUED'),
          AuditLog(action: 'APPROVE_TRANSITION', userId: 'Manager_01', timestamp: now.subtract(const Duration(days: 1)), status: 'FINALIZED'),
        ]),
      Lead(
        id: 'L-102',
        companyName: 'Beta Labs',
        estimatedValue: 28000,
        source: 'Referral',
        status: LeadStatus.negotiating,
        assignedTo: 'Daniyal',
        contactPerson: 'Sarah Chen',
        email: 'sarah@betalabs.io',
        phone: '+1-555-0202',
      )..auditLogs.add(AuditLog(action: 'Lead Created', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 2)), status: 'SUCCESS')),
      Lead(
        id: 'L-103',
        companyName: 'Delta Tech',
        estimatedValue: 75000,
        source: 'Cold Call',
        status: LeadStatus.pendingVerify,
        assignedTo: 'Umair',
        hasDocument: true,
        contactPerson: 'Mike Johnson',
        email: 'mike@deltatech.com',
      )..auditLogs.add(AuditLog(action: 'Lead Created', userId: 'Agent_02', timestamp: now.subtract(const Duration(days: 3)), status: 'SUCCESS')),
      Lead(
        id: 'L-104',
        companyName: 'Epsilon Co',
        estimatedValue: 32000,
        source: 'LinkedIn',
        status: LeadStatus.newContact,
        assignedTo: 'Umair',
        contactPerson: 'Lisa Park',
        email: 'lisa@epsilonco.com',
      ),
      Lead(
        id: 'L-105',
        companyName: 'Gamma Solutions',
        estimatedValue: 58000,
        source: 'Email Campaign',
        status: LeadStatus.closedWon,
        assignedTo: 'Daniyal',
        hasDocument: true,
        contactPerson: 'Tom Wilson',
      )..auditLogs.add(AuditLog(action: 'Lead Created', userId: 'Agent_01', timestamp: now.subtract(const Duration(days: 10)), status: 'SUCCESS')),
    ];
  }

  void addLead(Lead lead) {
    leads.add(lead);
    notifyListeners();
  }

  void updateLead(Lead updatedLead) {
    final idx = leads.indexWhere((l) => l.id == updatedLead.id);
    if (idx != -1) {
      leads[idx] = updatedLead;
      notifyListeners();
    }
  }

  List<Lead> get myLeads {
    if (currentUser?.role == UserRole.salesAgent) {
      return leads.where((l) => l.assignedTo == currentUser!.name.split(' ').first).toList();
    }
    return leads;
  }

  List<Lead> get pendingLeads => leads.where((l) => l.status == LeadStatus.pendingVerify).toList();

  double get totalPipelineValue => leads.where((l) => l.status != LeadStatus.closedLost).fold(0, (sum, l) => sum + l.estimatedValue);

  double get conversionRate {
    final total = leads.length;
    if (total == 0) return 0;
    final won = leads.where((l) => l.status == LeadStatus.closedWon).length;
    return (won / total) * 100;
  }

  Map<String, int> get leadsByStatus {
    final map = <String, int>{};
    for (final status in LeadStatus.values) {
      map[status.label] = leads.where((l) => l.status == status).length;
    }
    return map;
  }

  Map<String, double> get agentPerformance {
    final agents = leads.map((l) => l.assignedTo).toSet();
    final map = <String, double>{};
    for (final agent in agents) {
      final agentLeads = leads.where((l) => l.assignedTo == agent).toList();
      final won = agentLeads.where((l) => l.status == LeadStatus.closedWon).length;
      map[agent] = agentLeads.isEmpty ? 0 : (won / agentLeads.length) * 100;
    }
    return map;
  }
}
