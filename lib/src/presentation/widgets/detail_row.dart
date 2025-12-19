import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: NetifySpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: NetifyTextStyles.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: NetifyTextStyles.bodyMedium.copyWith(
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
