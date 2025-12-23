import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class ErrorCard extends StatelessWidget {
  final String error;

  const ErrorCard({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(NetifySpacing.lg),
      decoration: BoxDecoration(
        color: NetifyColors.errorBackground,
        borderRadius: BorderRadius.circular(NetifyRadius.md),
        border: Border.all(
          color: NetifyColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: NetifyColors.error,
                size: 18,
              ),
              const SizedBox(width: NetifySpacing.sm),
              Text(
                'ERROR',
                style: NetifyTextStyles.sectionTitle.copyWith(
                  color: NetifyColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: NetifySpacing.md),
          Text(
            error,
            style: NetifyTextStyles.errorText,
          ),
        ],
      ),
    );
  }
}
