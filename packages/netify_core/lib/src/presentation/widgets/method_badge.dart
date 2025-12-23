import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class MethodBadge extends StatelessWidget {
  final String method;

  const MethodBadge({
    super.key,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NetifySpacing.sm,
        vertical: NetifySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: NetifyColors.getMethodColor(method),
        borderRadius: BorderRadius.circular(NetifyRadius.sm),
      ),
      child: Text(
        method.toUpperCase(),
        style: NetifyTextStyles.methodBadge,
      ),
    );
  }
}
