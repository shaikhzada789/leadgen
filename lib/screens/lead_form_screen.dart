// lib/screens/lead_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';

class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _selectedSource = 'Web Inquiry';
  bool _isSaving = false;

  final List<String> _sources = [
    'Web Inquiry', 'Cold Call', 'Referral', 'LinkedIn', 'Email Campaign', 'Trade Show', 'Other',
  ];

  @override
  void dispose() {
    _companyCtrl.dispose();
    _valueCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final state = context.read<AppState>();
    final user = state.currentUser!;

    final lead = Lead(
      companyName: _companyCtrl.text.trim(),
      estimatedValue: double.tryParse(_valueCtrl.text.replaceAll(',', '')) ?? 0,
      source: _selectedSource,
      assignedTo: user.name.split(' ').first,
      contactPerson: _contactCtrl.text.trim().isEmpty ? null : _contactCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    lead.addLog('Lead Created', user.id, 'SUCCESS');

    await Future.delayed(const Duration(milliseconds: 800));
    state.addLead(lead);

    if (!mounted) return;
    _showSuccessDialog(lead);
  }

  void _showSuccessDialog(Lead lead) {
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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 50),
              ),
              const SizedBox(height: 16),
              const Text('Lead Save Ho Gaya!', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '${lead.companyName} (${lead.id}) SQLite database mein add ho gaya.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GlowButton(
                label: 'Dashboard pe Jao',
                icon: Icons.dashboard_rounded,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register New Lead', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                        Text('Screen 03 · Data Capture Form', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildSection('Client Information', Icons.business_rounded),
                      const SizedBox(height: 12),
                      _buildField('Client / Company Name *', _companyCtrl, Icons.business_rounded, validator: (v) => v!.isEmpty ? 'Company name required' : null),
                      const SizedBox(height: 12),
                      _buildField('Contact Person', _contactCtrl, Icons.person_rounded),
                      const SizedBox(height: 12),
                      _buildField('Email Address', _emailCtrl, Icons.email_rounded, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      _buildField('Phone Number', _phoneCtrl, Icons.phone_rounded, keyboardType: TextInputType.phone),
                      const SizedBox(height: 24),

                      _buildSection('Deal Information', Icons.monetization_on_rounded),
                      const SizedBox(height: 12),
                      _buildField('Estimated Value (\$) *', _valueCtrl, Icons.attach_money_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Value required' : null),
                      const SizedBox(height: 12),
                      _buildDropdown(),
                      const SizedBox(height: 24),

                      _buildSection('Notes', Icons.notes_rounded),
                      const SizedBox(height: 12),
                      _buildField('Additional Notes', _notesCtrl, Icons.notes_rounded, maxLines: 3),
                      const SizedBox(height: 32),

                      if (_isSaving)
                        const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                      else
                        GlowButton(
                          label: 'Save to Database',
                          icon: Icons.save_rounded,
                          isFullWidth: true,
                          onTap: _save,
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.cyan, size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: AppColors.borderGlass)),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
        filled: true,
        fillColor: AppColors.bgGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGlass),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGlass),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.bgGlass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSource,
          dropdownColor: const Color(0xFF1E293B),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          items: _sources
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedSource = v!),
        ),
      ),
    );
  }
}
