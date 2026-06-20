import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../models/lead_model.dart';
import '../utils/app_state.dart';
import 'agent_dashboard.dart';
import 'manager_dashboard.dart';
import 'executive_dashboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isLoggingIn = false;

  final List<_RoleOption> _roles = [
    _RoleOption(
      role: UserRole.salesAgent,
      user: AppUser(
          id: 'AGT_01', name: 'Daniyal Naeem', role: UserRole.salesAgent),
      title: 'Sales Agent',
      subtitle: 'TPS Level — Lead entry & management',
      icon: Icons.person_rounded,
      gradient: AppColors.cyanBlue,
    ),
    _RoleOption(
      role: UserRole.salesManager,
      user: AppUser(
          id: 'MGR_01', name: 'Manager Ali', role: UserRole.salesManager),
      title: 'Sales Manager',
      subtitle: 'Tactical Level — Approvals & team oversight',
      icon: Icons.group_rounded,
      gradient:
          const LinearGradient(colors: [AppColors.purple, AppColors.blue]),
    ),
    _RoleOption(
      role: UserRole.executive,
      user: AppUser(id: 'EXC_01', name: 'Sarim CEO', role: UserRole.executive),
      title: 'Executive',
      subtitle: 'Strategic Level — BI, reports & analytics',
      icon: Icons.analytics_rounded,
      gradient: const LinearGradient(colors: [AppColors.amber, AppColors.rose]),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login(_RoleOption option) async {
    setState(() => _isLoggingIn = true);

    context.read<AppState>().login(option.user);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    Widget destination;

    switch (option.role) {
      case UserRole.salesAgent:
        destination = const AgentDashboard();
        break;
      case UserRole.salesManager:
        destination = const ManagerDashboard();
        break;
      case UserRole.executive:
        destination = const ExecutiveDashboard();
        break;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => destination,
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          // Logo
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.cyan, AppColors.blue],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan.withOpacity(0.4),
                                  blurRadius: 25,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.shield_rounded,
                                color: Colors.white, size: 40),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'LeadGen Connect',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Role select karo aur system mein daakhil ho',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Role Cards
                          ..._roles.map(
                            (role) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _RoleCard(
                                option: role,
                                onTap: _isLoggingIn ? null : () => _login(role),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            'LeadGen MIS v1.0',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ================= ROLE MODEL =================
class _RoleOption {
  final UserRole role;
  final AppUser user;
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  _RoleOption({
    required this.role,
    required this.user,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

// ================= ROLE CARD =================
class _RoleCard extends StatefulWidget {
  final _RoleOption option;
  final VoidCallback? onTap;

  const _RoleCard({required this.option, this.onTap});

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGlass),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: widget.option.gradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.option.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.option.title,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(widget.option.subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
