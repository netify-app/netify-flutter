import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/netify_theme.dart';

class SectionCard extends StatefulWidget {
  final String title;
  final String content;
  final bool showCopyButton;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    this.showCopyButton = false,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  static const double _maxHeight = 180.0;
  static const int _maxLinesThreshold = 6;
  static const int _maxCharsThreshold = 200;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: NetifyColors.surface,
        borderRadius: BorderRadius.circular(NetifyRadius.md),
        border: Border.all(color: NetifyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NetifySpacing.md,
              vertical: NetifySpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.toUpperCase(),
                  style: NetifyTextStyles.sectionTitle,
                ),
                if (widget.showCopyButton)
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: Icon(
                      Icons.copy,
                      size: 18,
                      color: NetifyColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: NetifyColors.divider),
          Padding(
            padding: const EdgeInsets.all(NetifySpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isExpanded)
                  SelectableText(
                    widget.content,
                    style: NetifyTextStyles.bodyMedium.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: _maxHeight),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white.withValues(alpha: 0.1),
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SelectableText(
                          widget.content,
                          style: NetifyTextStyles.bodyMedium.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_shouldShowButton())
                  Padding(
                    padding: const EdgeInsets.only(top: NetifySpacing.sm),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Center(
                        child: Text(
                          _isExpanded ? 'Show Less' : 'Show More',
                          style: NetifyTextStyles.bodySmall.copyWith(
                            color: NetifyColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowButton() {
    // Simple heuristic: if content has many lines or is very long
    final lineCount = widget.content.split('\n').length;
    if (lineCount > _maxLinesThreshold) return true;
    return widget.content.length > _maxCharsThreshold;
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
