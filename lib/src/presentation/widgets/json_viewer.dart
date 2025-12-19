import 'dart:convert';

import 'package:flutter/material.dart';

import '../theme/netify_theme.dart';

class JsonViewer extends StatefulWidget {
  final dynamic data;
  final bool initiallyExpanded;

  const JsonViewer({
    super.key,
    required this.data,
    this.initiallyExpanded = true,
  });

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _buildJsonWidget(widget.data, 0),
    );
  }

  Widget _buildJsonWidget(dynamic data, int indent) {
    if (data == null) {
      return _buildValue('null', _JsonColors.nullColor);
    }
    if (data is bool) {
      return _buildValue(data.toString(), _JsonColors.boolColor);
    }
    if (data is num) {
      return _buildValue(data.toString(), _JsonColors.numberColor);
    }
    if (data is String) {
      return _buildValue('"$data"', _JsonColors.stringColor);
    }
    if (data is List) {
      return _buildList(data, indent);
    }
    if (data is Map) {
      return _buildMap(data, indent);
    }
    return _buildValue(data.toString(), NetifyColors.textPrimary);
  }

  Widget _buildValue(String value, Color color) {
    return Text(
      value,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: color,
      ),
    );
  }

  Widget _buildList(List data, int indent) {
    if (data.isEmpty) {
      return const Text(
        '[]',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: _JsonColors.bracketColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '[',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: _JsonColors.bracketColor,
          ),
        ),
        ...data.asMap().entries.map((entry) {
          final isLast = entry.key == data.length - 1;
          return Padding(
            padding: EdgeInsets.only(left: (indent + 1) * 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJsonWidget(entry.value, indent + 1),
                if (!isLast)
                  const Text(
                    ',',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: _JsonColors.bracketColor,
                    ),
                  ),
              ],
            ),
          );
        }),
        Padding(
          padding: EdgeInsets.only(left: indent * 16.0),
          child: const Text(
            ']',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: _JsonColors.bracketColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap(Map data, int indent) {
    if (data.isEmpty) {
      return const Text(
        '{}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: _JsonColors.bracketColor,
        ),
      );
    }

    final entries = data.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '{',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: _JsonColors.bracketColor,
          ),
        ),
        ...entries.asMap().entries.map((entry) {
          final isLast = entry.key == entries.length - 1;
          final mapEntry = entry.value;
          return Padding(
            padding: EdgeInsets.only(left: (indent + 1) * 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${mapEntry.key}"',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: _JsonColors.keyColor,
                  ),
                ),
                const Text(
                  ': ',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: _JsonColors.bracketColor,
                  ),
                ),
                _buildJsonWidget(mapEntry.value, indent + 1),
                if (!isLast)
                  const Text(
                    ',',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: _JsonColors.bracketColor,
                    ),
                  ),
              ],
            ),
          );
        }),
        Padding(
          padding: EdgeInsets.only(left: indent * 16.0),
          child: const Text(
            '}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: _JsonColors.bracketColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _JsonColors {
  static const Color keyColor = Color(0xFF6366F1); // Indigo 500
  static const Color stringColor = Color(0xFF10B981); // Emerald 500
  static const Color numberColor = Color(0xFFF59E0B); // Amber 500
  static const Color boolColor = Color(0xFFEC4899); // Pink 500
  static const Color nullColor = Color(0xFFEF4444); // Red 500
  static const Color bracketColor = Color(0xFF94A3B8); // Slate 400
}

class JsonSyntaxHighlighter extends StatelessWidget {
  final String jsonString;

  const JsonSyntaxHighlighter({
    super.key,
    required this.jsonString,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final decoded = jsonDecode(jsonString);
      return JsonViewer(data: decoded);
    } catch (_) {
      return SelectableText(
        jsonString,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: NetifyColors.textPrimary,
        ),
      );
    }
  }
}
