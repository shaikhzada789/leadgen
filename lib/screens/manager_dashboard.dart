import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pendingLeads = state.pendingLeads;
    final allLeads = state.leads;
    final agentPerf = state.agentPerformance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Dashboard"),
        backgroundColor: AppColors.purple,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          _buildTopBar(pendingLeads.length),
          _buildTabs(),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildPendingTab(pendingLeads),
                _buildAllLeadsTab(allLeads),
                _buildTeamTab(agentPerf),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP BAR =================
  Widget _buildTopBar(int pendingCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const Icon(Icons.analytics, color: AppColors.purple, size: 28),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sales Manager Panel",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  "Lead & Team Management",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          if (pendingCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$pendingCount Pending",
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _buildTabs() {
    final labels = ['Pending', 'All Leads', 'Team'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (i) {
          final selected = _selectedTab == i;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.purple : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= PENDING =================
  Widget _buildPendingTab(List<Lead> pending) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Pending Approvals",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (pending.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 60, color: Colors.green),
                  SizedBox(height: 10),
                  Text("No pending leads"),
                ],
              ),
            ),
          )
        else
          ...pending.map((lead) => Card(
                child: ListTile(
                  title: Text(lead.companyName),
                  subtitle: Text("Agent: ${lead.assignedTo}"),
                  trailing: Text("\$${lead.estimatedValue}"),
                ),
              )),
      ],
    );
  }

  // ================= ALL LEADS =================
  Widget _buildAllLeadsTab(List<Lead> leads) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "All Leads",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (leads.isEmpty)
          const Center(child: Text("No leads available"))
        else
          ...leads.map((lead) => Card(
                child: ListTile(
                  title: Text(lead.companyName),
                  subtitle: Text("Status: ${lead.status}"),
                  trailing: Text("\$${lead.estimatedValue}"),
                ),
              )),
      ],
    );
  }

  // ================= TEAM =================
  Widget _buildTeamTab(Map<String, double> perf) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Team Performance",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (perf.isEmpty)
          const Center(child: Text("No performance data"))
        else
          ...perf.entries.map((e) => Card(
                child: ListTile(
                  title: Text(e.key),
                  trailing: Text("${e.value.toStringAsFixed(1)}%"),
                ),
              )),
      ],
    );
  }
}
