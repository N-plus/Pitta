import 'package:flutter/material.dart';

import '../models/comparison_record.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key, required this.record});

  final ComparisonRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(record.item.name)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 0.4,
                child: CustomPaint(
                  painter: _SilhouettePainter(record),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: record
                  .comments()
                  .map((c) => Text(c))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  _SilhouettePainter(this.record);
  final ComparisonRecord record;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = Colors.blue.shade200;
    final clothPaint = Paint()..color = Colors.red.withOpacity(0.5);

    final bodyWidth = record.profile.chest;
    final clothWidth = record.item.bodyWidth;
    final scale = size.width / (bodyWidth > clothWidth ? bodyWidth : clothWidth);

    final bodyRect = Rect.fromLTWH(
      (size.width - bodyWidth * scale) / 2,
      size.height * 0.2,
      bodyWidth * scale,
      size.height * 0.6,
    );
    final clothRect = Rect.fromLTWH(
      (size.width - clothWidth * scale) / 2,
      size.height * 0.2,
      clothWidth * scale,
      size.height * 0.6,
    );

    canvas.drawRect(bodyRect, bodyPaint);
    canvas.drawRect(clothRect, clothPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
