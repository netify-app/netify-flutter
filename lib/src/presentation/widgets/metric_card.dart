import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NetifySpacing.md),
      decoration: BoxDecoration(
        color: NetifyColors.surface,
        borderRadius: BorderRadius.circular(NetifyRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: NetifyColors.textHint,
              ),
              const SizedBox(width: NetifySpacing.xs),
              Text(
                label.toUpperCase(),
                style: NetifyTextStyles.metricLabel,
              ),
            ],
          ),
          const SizedBox(height: NetifySpacing.sm),
          Text(
            value,
            style: NetifyTextStyles.metricValue.copyWith(
              color: valueColor ?? NetifyColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
