import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import 'auth_screen.dart';

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String hint;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.hint,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      icon: Icons.shield_rounded,
      title: 'LeadGen Connect MIS',
      subtitle:
          'A professional Lead Management System with Role-Based Access Control. It supports Sales Agent, Manager, and Executive dashboards.',
      accentColor: AppColors.cyan,
      hint: 'Select a role to access your dashboard',
    ),
    OnboardingPage(
      icon: Icons.add_circle_rounded,
      title: 'Create New Leads',
      subtitle:
          'Use the “New Lead” feature to register client details including name, value, and source. All data is stored securely in the system database.',
      accentColor: AppColors.blue,
      hint: 'Fill in lead information carefully',
    ),
    OnboardingPage(
      icon: Icons.swap_horiz_rounded,
      title: 'Update Lead Status',
      subtitle:
          'Open lead details and update status. Closing a deal requires proper validation and document verification to ensure data integrity.',
      accentColor: AppColors.amber,
      hint: 'Documents are required before closing a lead',
    ),
    OnboardingPage(
      icon: Icons.supervisor_account_rounded,
      title: 'Manager Approval System',
      subtitle:
          'Managers review pending leads, verify contracts, and approve or reject deals based on compliance and accuracy.',
      accentColor: AppColors.emerald,
      hint: 'Approval is required before final closure',
    ),
    OnboardingPage(
      icon: Icons.bar_chart_rounded,
      title: 'Executive Analytics',
      subtitle:
          'Executives access advanced analytics, performance dashboards, conversion reports, and business intelligence insights.',
      accentColor: AppColors.purple,
      hint: 'Swipe dashboards to explore insights',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgGlass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderGlass),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Transform.scale(
                              scale: _currentPage == index
                                  ? _pulseAnim.value
                                  : 1.0,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: page.accentColor.withOpacity(0.1),
                                  border: Border.all(
                                      color: page.accentColor.withOpacity(0.4)),
                                ),
                                child: Icon(page.icon,
                                    color: page.accentColor, size: 55),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: page.accentColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: page.accentColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: page.accentColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              page.hint,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: page.accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? _pages[_currentPage].accentColor
                          : AppColors.textMuted,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: GlowButton(
                  label: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  icon: _currentPage == _pages.length - 1
                      ? Icons.rocket_launch
                      : Icons.arrow_forward,
                  gradient: LinearGradient(
                    colors: [_pages[_currentPage].accentColor, AppColors.blue],
                  ),
                  isFullWidth: true,
                  onTap: _next,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
