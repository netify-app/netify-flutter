import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class NetifySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const NetifySearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search URL, method, status...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: NetifySpacing.lg,
        vertical: NetifySpacing.md,
      ),
      decoration: BoxDecoration(
        color: NetifyColors.surface,
        borderRadius: BorderRadius.circular(NetifyRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: NetifyTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: NetifyTextStyles.bodyMedium.copyWith(
            color: NetifyColors.textHint,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: NetifyColors.textHint,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: NetifySpacing.lg,
            vertical: 14,
          ),
          isDense: true,
        ),
      ),
    );
  }
}
