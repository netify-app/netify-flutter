import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class StatusBadge extends StatelessWidget {
  final int? statusCode;

  const StatusBadge({
    super.key,
    required this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NetifySpacing.sm,
        vertical: NetifySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: NetifyColors.getStatusBackgroundColor(statusCode),
        borderRadius: BorderRadius.circular(NetifyRadius.sm),
      ),
      child: Text(
        statusCode?.toString() ?? '...',
        style: NetifyTextStyles.statusBadge,
      ),
    );
  }
}
