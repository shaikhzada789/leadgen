// lib/screens/lead_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';

class LeadDetailScreen extends StatefulWidget {
  final Lead lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late Lead _lead;
  bool _hasDoc = false;

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _hasDoc = _lead.hasDocument;
  }

  void _logAction(String action, String logStatus) {
    final state = context.read<AppState>();
    final user = state.currentUser!;
    setState(() {
      _lead.addLog(action, user.id, logStatus);
      if (action == 'Log Call' || action == 'Log Chat') {
        _lead.status = LeadStatus.negotiating;
      }
    });
    state.updateLead(_lead);
    _showSnack('$action logged successfully');
  }

  void _uploadDocument() {
    setState(() {
      _hasDoc = true;
      _lead.hasDocument = true;
      _lead.addLog('UPLOAD_DOC_HASH_0x${DateTime.now().millisecond.toRadixString(16).toUpperCase()}', 'Agent_01', 'QUEUED');
    });
    context.read<AppState>().updateLead(_lead);
    _showSnack('Document uploaded! Status: Queued for Manager review');
  }

  void _attemptClose() {
    if (!_hasDoc) {
      _showBlockedDialog();
      return;
    }
    setState(() {
      _lead.status = LeadStatus.pendingVerify;
      _lead.addLog('ATTEMPT_CLOSE (Pending Manager Approval)', 'Agent_01', 'QUEUED');
    });
    context.read<AppState>().updateLead(_lead);
    _showSnack('Lead submitted for Manager approval!');
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          borderColor: AppColors.rose.withOpacity(0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.rose.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.block_rounded, color: AppColors.rose, size: 48),
              ),
              const SizedBox(height: 16),
              const Text('BLOCKED — TR09', style: TextStyle(color: AppColors.rose, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Document upload ke bagair deal close nahi ho sakti.\nPehle contract document upload karo!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GlowButton(
                      label: 'Upload Document',
                      icon: Icons.upload_file_rounded,
                      gradient: AppColors.cyanBlue,
                      isFullWidth: true,
                      onTap: () {
                        Navigator.of(context).pop();
                        _uploadDocument();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Cancel',
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.bgDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canClose = context.read<AppState>().currentUser?.role == UserRole.salesAgent;

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildLeadCard(),
                    const SizedBox(height: 16),
                    if (canClose) _buildActionButtons(),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                    const SizedBox(height: 16),
                    _buildDocumentSection(),
                    const SizedBox(height: 16),
                    _buildAuditLog(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgGlass,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profiler: ${_lead.id}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
              const Text('Lead Detail View', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard() {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_lead.companyName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  'Value: \$${_lead.estimatedValue.toStringAsFixed(0)} · Assigned: ${_lead.assignedTo}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                if (_lead.contactPerson != null) ...[
                  const SizedBox(height: 4),
                  Text('Contact: ${_lead.contactPerson}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          StatusBadge(status: _lead.status),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Actions', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SecondaryButton(label: 'Log Chat', icon: Icons.chat_bubble_outline_rounded, onTap: () => _logAction('Log Chat', 'SUCCESS')),
            SecondaryButton(label: 'Log Call', icon: Icons.phone_outlined, onTap: () => _logAction('Log Call', 'SUCCESS')),
            if (!_hasDoc)
              GlowButton(label: 'Upload Doc', icon: Icons.upload_file_rounded, onTap: _uploadDocument),
            if (_lead.status != LeadStatus.closedWon && _lead.status != LeadStatus.pendingVerify)
              GlowButton(
                label: 'Mark Closed-Won',
                icon: Icons.check_circle_rounded,
                gradient: AppColors.emeraldGreen,
                onTap: _attemptClose,
              ),
            if (_lead.status == LeadStatus.pendingVerify)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.amber.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hourglass_empty_rounded, color: AppColors.amber, size: 16),
                    SizedBox(width: 8),
                    Text('Awaiting Manager Approval', style: TextStyle(color: AppColors.amber, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            if (_lead.status == LeadStatus.closedWon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.emerald.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, color: AppColors.emerald, size: 16),
                    SizedBox(width: 8),
                    Text('Deal Closed & Locked', style: TextStyle(color: AppColors.emerald, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deal Information', style: TextStyle(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          _infoRow('Source', _lead.source),
          _infoRow('Lead ID', _lead.id),
          _infoRow('Assigned To', _lead.assignedTo),
          if (_lead.email != null) _infoRow('Email', _lead.email!),
          if (_lead.phone != null) _infoRow('Phone', _lead.phone!),
          if (_lead.notes != null) _infoRow('Notes', _lead.notes!),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildDocumentSection() {
    return GlassCard(
      borderColor: _hasDoc ? AppColors.emerald.withOpacity(0.3) : AppColors.borderGlass,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_hasDoc ? AppColors.emerald : AppColors.textMuted).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _hasDoc ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: _hasDoc ? AppColors.emerald : AppColors.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hasDoc ? 'Contract Document' : 'No Document Uploaded',
                  style: TextStyle(
                    color: _hasDoc ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _hasDoc ? 'Document verified & queued' : 'Closing ke liye zaroori hai',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!_hasDoc)
            GlowButton(label: 'Upload', icon: Icons.upload_rounded, isSmall: true, onTap: _uploadDocument),
        ],
      ),
    );
  }

  Widget _buildAuditLog() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_clock_rounded, color: AppColors.cyan, size: 16),
              SizedBox(width: 8),
              Text('Immutable Audit Log', style: TextStyle(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          if (_lead.auditLogs.isEmpty)
            const Text('No activity yet', style: TextStyle(color: AppColors.textMuted, fontSize: 13))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lead.auditLogs.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.borderGlass, height: 20),
              itemBuilder: (_, i) {
                final log = _lead.auditLogs[_lead.auditLogs.length - 1 - i];
                Color statusColor;
                switch (log.status) {
                  case 'SUCCESS':
                  case 'FINALIZED':
                    statusColor = AppColors.emerald;
                    break;
                  case 'QUEUED':
                    statusColor = AppColors.blue;
                    break;
                  default:
                    statusColor = AppColors.rose;
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.action, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(log.userId, style: const TextStyle(color: AppColors.cyan, fontSize: 11)),
                              const Text(' · ', style: TextStyle(color: AppColors.textMuted)),
                              Text(
                                '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(log.status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
