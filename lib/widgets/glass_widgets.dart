// lib/widgets/glass_widgets.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/lead_model.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final double? width;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.borderRadius = 16,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.borderGlass,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class GlowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final LinearGradient gradient;
  final bool isFullWidth;
  final bool isSmall;

  const GlowButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.gradient = AppColors.cyanBlue,
    this.isFullWidth = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 18,
          vertical: isSmall ? 8 : 12,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.35),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: isSmall ? 16 : 18),
            SizedBox(width: isSmall ? 6 : 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: isSmall ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.bgGlass,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final LeadStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case LeadStatus.newContact: return AppColors.blue;
      case LeadStatus.negotiating: return AppColors.amber;
      case LeadStatus.pendingVerify: return AppColors.purple;
      case LeadStatus.closedWon: return AppColors.emerald;
      case LeadStatus.closedLost: return AppColors.rose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value, style: TextStyle(color: valueColor, fontSize: 28, fontWeight: FontWeight.w700)),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: valueColor, size: 20),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class MeshBackground extends StatelessWidget {
  final Widget child;

  const MeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [Color(0xFF0F172A), Color(0xFF020617)],
            ),
          ),
        ),
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.cyan.withOpacity(0.12), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.blue.withOpacity(0.08), Colors.transparent],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class LeadListTile extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadListTile({super.key, required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.cyan, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lead.companyName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 3),
                Text('${lead.id} · \$${lead.estimatedValue.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(status: lead.status),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
