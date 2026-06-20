// lib/screens/executive_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';
import 'auth_screen.dart';

class ExecutiveDashboard extends StatefulWidget {
  const ExecutiveDashboard({super.key});

  @override
  State<ExecutiveDashboard> createState() => _ExecutiveDashboardState();
}

class _ExecutiveDashboardState extends State<ExecutiveDashboard> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
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

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
            child: Column(
              children: [
                _buildTopBar(context),
                _buildTabs(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTab,
                    children: [
                      _buildStrategicTab(state),
                      _buildAnalyticsTab(state),
                      _buildAITab(state),
                      _buildAuditTab(state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.amber, AppColors.rose]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sarim CEO', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                Text('Executive · Strategic DSS Level', style: TextStyle(color: AppColors.amber, fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<AppState>().logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.bgGlass, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderGlass)),
              child: const Icon(Icons.logout_rounded, color: AppColors.textSecondary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final labels = ['Strategic', 'Analytics', 'AI Forecast', 'Audit'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (i) => Padding(
            padding: EdgeInsets.only(right: i < labels.length - 1 ? 10 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  gradient: _selectedTab == i ? const LinearGradient(colors: [AppColors.amber, AppColors.rose]) : null,
                  color: _selectedTab == i ? null : AppColors.bgGlass,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _selectedTab == i ? Colors.transparent : AppColors.borderGlass),
                ),
                child: Text(labels[i], style: TextStyle(
                  color: _selectedTab == i ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600, fontSize: 13,
                )),
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildStrategicTab(AppState state) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (r) => AppColors.purpleCyan.createShader(r),
          child: const Text('Strategic Enterprise View', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 4),
        const Text('Screen 16 · DSS Level Dashboard', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(child: StatCard(label: 'Pipeline Value', value: '\$${(state.totalPipelineValue / 1000).toStringAsFixed(0)}K', valueColor: AppColors.textPrimary)),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Global Conversion', value: '${state.conversionRate.toStringAsFixed(1)}%', valueColor: AppColors.emerald, icon: Icons.trending_up_rounded)),
            const SizedBox(width: 12),
            Expanded(child: const StatCard(label: 'Avg Turnaround', value: '14 Days', valueColor: AppColors.cyan)),
          ],
        ),
        const SizedBox(height: 16),

        // Leads by status
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portfolio Overview', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ...state.leadsByStatus.entries.map((e) {
                final colors = {
                  'New Contact': AppColors.blue,
                  'Negotiating': AppColors.amber,
                  'Pending Verify': AppColors.purple,
                  'Closed Won': AppColors.emerald,
                  'Closed Lost': AppColors.rose,
                };
                final color = colors[e.key] ?? AppColors.textMuted;
                final total = state.leads.isEmpty ? 1 : state.leads.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text('${e.value}', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: e.value / total,
                          backgroundColor: AppColors.bgGlass,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab(AppState state) {
    // Monthly data for chart
    final barGroups = [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: AppColors.blue.withOpacity(0.7), width: 20, borderRadius: BorderRadius.circular(4))]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 72, color: AppColors.cyan.withOpacity(0.7), width: 20, borderRadius: BorderRadius.circular(4))]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 98, gradient: const LinearGradient(colors: [AppColors.emerald, Color(0xFF34D399)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 20, borderRadius: BorderRadius.circular(4))]),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('BI Analytics', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const Text('Screen 17 · Conversion Analytics Graph', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),

        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly Revenue Pipeline (Q3)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    backgroundColor: Colors.transparent,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, _) {
                            const labels = ['Jul', 'Aug', 'Sep'];
                            return Text(labels[val.toInt()], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Pie-like status breakdown
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Lead Status Breakdown', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: state.leads.where((l) => l.status == LeadStatus.closedWon).length.toDouble(), color: AppColors.emerald, title: 'Won', titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), radius: 70),
                      PieChartSectionData(value: state.leads.where((l) => l.status == LeadStatus.negotiating).length.toDouble(), color: AppColors.amber, title: 'Nego', titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), radius: 70),
                      PieChartSectionData(value: state.leads.where((l) => l.status == LeadStatus.newContact).length.toDouble(), color: AppColors.blue, title: 'New', titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), radius: 70),
                      PieChartSectionData(value: state.leads.where((l) => l.status == LeadStatus.pendingVerify).length.toDouble(), color: AppColors.purple, title: 'Pending', titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), radius: 70),
                    ],
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAITab(AppState state) {
    final predictions = [
      _AIPrediction('Delta Tech', 82, true, 'High probability of closing next week'),
      _AIPrediction('Epsilon Co', 35, false, 'Churn risk: 65% — intervention needed'),
      _AIPrediction('Beta Labs', 61, true, 'Moderate win probability with nurturing'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('AI Forecast Engine', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const Text('Screen 18 · Predictive Scoring Model', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),

        GlassCard(
          borderColor: AppColors.cyan.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.cyan, size: 18),
                  const SizedBox(width: 8),
                  const Text('AI Powered Predictions', style: TextStyle(color: AppColors.cyan, fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
                    child: const Text('Live', style: TextStyle(color: AppColors.cyan, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...predictions.map((p) => _buildPredictionCard(p)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Model Info', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              _InfoRow(label: 'Algorithm', value: 'Statistical Classifier v2.1'),
              _InfoRow(label: 'Training Data', value: '2,400+ historical leads'),
              _InfoRow(label: 'Accuracy', value: '87.4%'),
              _InfoRow(label: 'Last Updated', value: '2026-06-20'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionCard(_AIPrediction p) {
    final color = p.isPositive ? AppColors.emerald : AppColors.rose;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgGlass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(p.company, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const Spacer(),
                Text('${p.probability}%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: p.probability / 100,
                backgroundColor: AppColors.bgGlass,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(p.insight, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditTab(AppState state) {
    final allLogs = state.leads
        .expand((l) => l.auditLogs.map((log) => _AuditEntry(log, l.id, l.companyName)))
        .toList()
      ..sort((a, b) => b.log.timestamp.compareTo(a.log.timestamp));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Master System Logs', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const Text('Screen 19 · Immutable Audit Trail', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 16),

        // Header
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: const Row(
            children: [
              Expanded(child: Text('TIMESTAMP', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600))),
              Expanded(child: Text('USER_ID', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('ACTION', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600))),
              Text('STATE', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 8),

        ...allLogs.take(20).map((entry) {
          Color statusColor;
          switch (entry.log.status) {
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.log.timestamp.month}/${entry.log.timestamp.day} ${entry.log.timestamp.hour.toString().padLeft(2,'0')}:${entry.log.timestamp.minute.toString().padLeft(2,'0')}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ),
                  Expanded(child: Text(entry.log.userId, style: const TextStyle(color: AppColors.cyan, fontSize: 10, fontWeight: FontWeight.w500))),
                  Expanded(flex: 2, child: Text(entry.log.action, style: const TextStyle(color: AppColors.textPrimary, fontSize: 10))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(entry.log.status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          );
        }),

        if (allLogs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text('No audit logs yet', style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _AIPrediction {
  final String company;
  final int probability;
  final bool isPositive;
  final String insight;

  const _AIPrediction(this.company, this.probability, this.isPositive, this.insight);
}

class _AuditEntry {
  final AuditLog log;
  final String leadId;
  final String company;

  _AuditEntry(this.log, this.leadId, this.company);
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
