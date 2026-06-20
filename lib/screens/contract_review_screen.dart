// lib/screens/contract_review_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';

class ContractReviewScreen extends StatefulWidget {
  final Lead lead;

  const ContractReviewScreen({super.key, required this.lead});

  @override
  State<ContractReviewScreen> createState() => _ContractReviewScreenState();
}

class _ContractReviewScreenState extends State<ContractReviewScreen> {
  bool _isProcessing = false;

  Future<void> _approve() async {
    if (!widget.lead.hasDocument) {
      _showError();
      return;
    }
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    final state = context.read<AppState>();
    widget.lead.status = LeadStatus.closedWon;
    widget.lead.addLog('APPROVE_TRANSITION', 'Manager_01', 'FINALIZED');
    state.updateLead(widget.lead);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    _showSuccessDialog();
  }

  Future<void> _reject() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final state = context.read<AppState>();
    widget.lead.status = LeadStatus.closedLost;
    widget.lead.addLog('REJECT_CONTRACT', 'Manager_01', 'REJECTED');
    state.updateLead(widget.lead);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    _showRejectDialog();
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document missing — approve nahi ho sakta!'),
        backgroundColor: AppColors.rose,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          borderColor: AppColors.emerald.withOpacity(0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0x1A10B981), shape: BoxShape.circle),
                child: const Icon(Icons.verified_rounded, color: AppColors.emerald, size: 56),
              ),
              const SizedBox(height: 16),
              const Text('Deal Closed Successfully!', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Validation Passed. ${widget.lead.id} officially "Closed-Won" mein move ho gaya.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgGlass,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Rule: Doc == True && Role >= Manager ✓',
                  style: TextStyle(color: AppColors.cyan, fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 20),
              GlowButton(
                label: 'Acknowledge',
                icon: Icons.thumb_up_rounded,
                isFullWidth: true,
                gradient: AppColors.emeraldGreen,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          borderColor: AppColors.rose.withOpacity(0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0x1AF43F5E), shape: BoxShape.circle),
                child: const Icon(Icons.cancel_rounded, color: AppColors.rose, size: 56),
              ),
              const SizedBox(height: 16),
              const Text('Contract Rejected', style: TextStyle(color: AppColors.rose, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '${widget.lead.companyName} lead "Closed-Lost" mark ho gaya.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GlowButton(
                label: 'Back to Queue',
                icon: Icons.arrow_back_rounded,
                isFullWidth: true,
                gradient: AppColors.dangerRed,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _buildContractView()),
                    Container(width: 1, color: AppColors.borderGlass),
                    SizedBox(width: 220, child: _buildControls()),
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
              decoration: BoxDecoration(color: AppColors.bgGlass, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderGlass)),
              child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reviewing ${widget.lead.id}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                Text(widget.lead.companyName, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          StatusBadge(status: widget.lead.status),
        ],
      ),
    );
  }

  Widget _buildContractView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        child: Column(
          children: [
            // Document header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Column(
                children: [
                  const Text('CONTRACT AGREEMENT', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2)),
                  const Divider(color: Colors.black, thickness: 2),
                  const SizedBox(height: 8),
                  Text('This agreement is made between LeadGen Connect and ${widget.lead.companyName}.',
                      style: const TextStyle(color: Colors.black87, fontSize: 12)),
                  const SizedBox(height: 12),
                  ...List.generate(4, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                  )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade800, width: 2)),
                          child: Text('DIGITALLY\nSIGNED', style: TextStyle(color: Colors.blue.shade800, fontSize: 8, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Doc status
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    widget.lead.hasDocument ? Icons.verified_rounded : Icons.warning_amber_rounded,
                    color: widget.lead.hasDocument ? AppColors.emerald : AppColors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.lead.hasDocument ? 'Document verified & ready for review' : 'Document not uploaded — approval blocked',
                    style: TextStyle(
                      color: widget.lead.hasDocument ? AppColors.emerald : AppColors.amber,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manager Controls', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          // Info
          GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ctrlRow('Lead ID', widget.lead.id),
                _ctrlRow('Company', widget.lead.companyName),
                _ctrlRow('Agent', widget.lead.assignedTo),
                _ctrlRow('Value', '\$${widget.lead.estimatedValue.toStringAsFixed(0)}'),
                _ctrlRow('Document', widget.lead.hasDocument ? '✅ Ready' : '❌ Missing'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_isProcessing)
            const Center(child: CircularProgressIndicator(color: AppColors.purple))
          else ...[
            GlowButton(
              label: 'Approve & Close',
              icon: Icons.check_circle_rounded,
              isFullWidth: true,
              gradient: AppColors.emeraldGreen,
              onTap: _approve,
            ),
            const SizedBox(height: 12),
            GlowButton(
              label: 'Reject Contract',
              icon: Icons.cancel_rounded,
              isFullWidth: true,
              gradient: AppColors.dangerRed,
              onTap: _reject,
            ),
          ],

          const Spacer(),
          const Text(
            'Rule: Doc == True && Role >= Manager required for approval',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _ctrlRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
