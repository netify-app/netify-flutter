import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/netify_theme.dart';
import 'json_viewer.dart';

class JsonSectionCard extends StatefulWidget {
  final String title;
  final dynamic data;
  final bool showCopyButton;

  const JsonSectionCard({
    super.key,
    required this.title,
    required this.data,
    this.showCopyButton = false,
  });

  @override
  State<JsonSectionCard> createState() => _JsonSectionCardState();
}

class _JsonSectionCardState extends State<JsonSectionCard> {
  bool _isExpanded = false;
  static const double _maxHeight = 150.0;

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
                      size: 20,
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
                  _buildContent()
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
                        child: _buildContent(),
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
    // Simple heuristic: if it's a Map/List with > 3 items or String > 200 chars
    if (widget.data is Map) {
      return (widget.data as Map).length > 3;
    }
    if (widget.data is List) {
      return (widget.data as List).length > 3;
    }
    if (widget.data is String) {
      return (widget.data as String).length > 200;
    }
    return false;
  }

  Widget _buildContent() {
    if (widget.data == null) {
      return Text(
        'null',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: NetifyColors.textSecondary,
        ),
      );
    }

    if (widget.data is String) {
      try {
        final decoded = jsonDecode(widget.data as String);
        return JsonViewer(data: decoded);
      } catch (_) {
        return SelectableText(
          widget.data as String,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: NetifyColors.textPrimary,
          ),
        );
      }
    }

    if (widget.data is Map || widget.data is List) {
      return JsonViewer(data: widget.data);
    }

    return SelectableText(
      widget.data.toString(),
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: NetifyColors.textPrimary,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    String content;
    if (widget.data is String) {
      content = widget.data as String;
    } else if (widget.data is Map || widget.data is List) {
      content = const JsonEncoder.withIndent('  ').convert(widget.data);
    } else {
      content = widget.data.toString();
    }

    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
