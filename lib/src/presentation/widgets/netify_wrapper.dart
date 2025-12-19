import 'package:flutter/material.dart';

import '../../core/entities/netify_config.dart';
import '../pages/netify_panel.dart';
import 'netify_bubble.dart';

class NetifyWrapper extends StatelessWidget {
  final Widget child;
  final NetifyEntryMode entryMode;

  const NetifyWrapper({
    super.key,
    required this.child,
    this.entryMode = NetifyEntryMode.bubble,
  });

  void _openNetifyPanel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NetifyPanel(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Add bubble overlay if needed
    if (entryMode == NetifyEntryMode.bubble) {
      result = Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            result,
            NetifyBubble(
              onTap: () => _openNetifyPanel(context),
            ),
          ],
        ),
      );
    }

    return result;
  }
}

