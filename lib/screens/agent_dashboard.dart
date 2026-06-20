// lib/screens/agent_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';
import 'lead_form_screen.dart';
import 'lead_detail_screen.dart';
import 'auth_screen.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({super.key});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser!;
    final myLeads = state.myLeads;

    final activeLeads = myLeads.where((l) => l.status == LeadStatus.newContact || l.status == LeadStatus.negotiating).length;
    final pendingLeads = myLeads.where((l) => l.status == LeadStatus.pendingVerify).length;
    final wonLeads = myLeads.where((l) => l.status == LeadStatus.closedWon).length;

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
            child: Column(
              children: [
                _buildTopBar(user, context),
                _buildTabs(),
                Expanded(
                  child: _selectedTab == 0
                      ? _buildOverviewTab(activeLeads, pendingLeads, wonLeads, myLeads, state)
                      : _buildLeadsTab(myLeads),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LeadFormScreen()),
        ),
        backgroundColor: AppColors.cyan,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Lead', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildTopBar(AppUser user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.cyanBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                const Text('Sales Agent · TPS Level', style: TextStyle(color: AppColors.cyan, fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<AppState>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgGlass,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.textSecondary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          _TabBtn(label: 'Overview', isActive: _selectedTab == 0, onTap: () => setState(() => _selectedTab = 0)),
          const SizedBox(width: 10),
          _TabBtn(label: 'My Leads', isActive: _selectedTab == 1, onTap: () => setState(() => _selectedTab = 1)),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(int active, int pending, int won, List<Lead> myLeads, AppState state) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header
        const SizedBox(height: 8),
        const Text('Operational Overview', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('Real-time lead pipeline status', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),

        // Stat cards
        Row(
          children: [
            Expanded(child: StatCard(label: 'Active Leads', value: '$active', valueColor: AppColors.blue, icon: Icons.trending_up_rounded)),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Pending Verify', value: '$pending', valueColor: AppColors.amber)),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Closed Won', value: '$won', valueColor: AppColors.emerald, icon: Icons.check_circle_rounded)),
          ],
        ),
        const SizedBox(height: 24),

        // Pipeline value
        GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.cyanBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.attach_money_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Pipeline Value', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text(
                    '\$${myLeads.where((l) => l.status != LeadStatus.closedLost).fold(0.0, (s, l) => s + l.estimatedValue).toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Recent leads
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Leads', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: const Text('See All', style: TextStyle(color: AppColors.cyan, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...myLeads.take(3).map((lead) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LeadListTile(
            lead: lead,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LeadDetailScreen(lead: lead)),
            ),
          ),
        )),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildLeadsTab(List<Lead> myLeads) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Lead Roster', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
            Text('${myLeads.length} total', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 16),
        if (myLeads.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, color: AppColors.textMuted, size: 60),
                  SizedBox(height: 16),
                  Text('Koi lead nahi — pehli lead add karo!', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                ],
              ),
            ),
          )
        else
          ...myLeads.map((lead) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LeadListTile(
              lead: lead,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => LeadDetailScreen(lead: lead)),
              ),
            ),
          )),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabBtn({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.cyanBlue : null,
          color: isActive ? null : AppColors.bgGlass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? Colors.transparent : AppColors.borderGlass),
          boxShadow: isActive ? [BoxShadow(color: AppColors.cyan.withOpacity(0.3), blurRadius: 12)] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
