import 'package:flutter/material.dart';

import '../models/comparison_record.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key, required this.record});

  final ComparisonRecord record;

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late Map<String, double> childBodySize;
  late Map<String, double> clothesSize;

  @override
  void initState() {
    super.initState();
    childBodySize = {
      '肩幅': widget.record.profile.shoulderWidth,
      '身幅': widget.record.profile.chest,
      '着丈': widget.record.profile.height * 0.38,
      '袖丈': widget.record.profile.height * 0.25,
    };
    clothesSize = {
      '肩幅': widget.record.item.shoulderWidth,
      '身幅': widget.record.item.bodyWidth,
      '着丈': widget.record.item.length,
      '袖丈': widget.record.item.sleeveLength,
    };

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getComparisonColor(double difference) {
    if (difference.abs() <= 1) {
      return Colors.green;
    } else if (difference.abs() <= 3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getComparisonText(String part, double difference) {
    String status;
    if (difference.abs() <= 1) {
      status = 'ちょうど良い';
    } else if (difference > 0) {
      if (difference <= 3) {
        status = '少し大きめ';
      } else {
        status = '大きすぎ';
      }
    } else {
      if (difference >= -3) {
        status = '少し小さめ';
      } else {
        status = '小さすぎ';
      }
    }
    final diffText =
        difference > 0 ? '+${difference.toStringAsFixed(1)}' : difference.toStringAsFixed(1);
    return '$part：$diffText cm（$status）';
  }

  Widget _buildBodySilhouette({required bool isChild}) {
    final sizes = isChild ? childBodySize : clothesSize;
    final color = isChild ? Colors.blue[300]! : Colors.pink[300]!;

    final shoulderWidth = sizes['肩幅']! * 2;
    final bodyWidth = sizes['身幅']! * 2;
    final bodyHeight = sizes['着丈']! * 1.5;
    final sleeveLength = sizes['袖丈']! * 2;

    return SizedBox(
      width: 120,
      height: 140,
      child: CustomPaint(
        painter: _SilhouettePainter(
          shoulderWidth: shoulderWidth.clamp(35, 70),
          bodyWidth: bodyWidth.clamp(40, 80),
          bodyHeight: bodyHeight.clamp(60, 100),
          sleeveLength: sleeveLength.clamp(20, 60),
          color: color,
          isChild: isChild,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandName = widget.record.item.brand;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        title: Text(
          widget.record.item.name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black87),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[600]),
                      const SizedBox(width: 8),
                      const Text('見方のコツ'),
                    ],
                  ),
                  content: const Text(
                    '🟢 緑色：ちょうど良いサイズ\n🟠 オレンジ：少し違うけど着れる\n🔴 赤色：サイズが合わない可能性\n\n着丈は少し長めでも問題ありませんが、肩幅と身幅は重要です！',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('わかった！'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.pink.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.checkroom,
                          color: Colors.pink[400],
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.record.item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (brandName != null)
                              Text(
                                brandName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'シルエット比較',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'お子さんの体型',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildBodySilhouette(isChild: true),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.compare_arrows,
                                color: Colors.pink[300],
                                size: 30,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[400],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '服のサイズ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildBodySilhouette(isChild: false),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.pink[400]),
                          const SizedBox(width: 8),
                          Text(
                            '詳細比較結果',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...childBodySize.keys.map((part) {
                        final difference = clothesSize[part]! - childBodySize[part]!;
                        final statusColor = _getComparisonColor(difference);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getComparisonText(part, difference),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('お気に入りに追加しました！'),
                            backgroundColor: Colors.pink[400],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('お気に入り'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.pink[600],
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.pink[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('購入リストに追加しました！'),
                            backgroundColor: Colors.green[400],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('購入予定'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  const _SilhouettePainter({
    required this.shoulderWidth,
    required this.bodyWidth,
    required this.bodyHeight,
    required this.sleeveLength,
    required this.color,
    required this.isChild,
  });

  final double shoulderWidth;
  final double bodyWidth;
  final double bodyHeight;
  final double sleeveLength;
  final Color color;
  final bool isChild;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color.withOpacity(isChild ? 0.7 : 0.5)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isChild ? 2 : 1;

    // Head
    final headRadius = 12.0;
    final headCenter = Offset(size.width / 2, headRadius + 4);
    canvas.drawCircle(headCenter, headRadius, fillPaint);
    if (isChild) {
      canvas.drawCircle(headCenter, headRadius, strokePaint);
    }

    // Torso
    final topY = headCenter.dy + headRadius + 4;
    final bottomY = topY + bodyHeight;
    final topLeft = Offset((size.width - shoulderWidth) / 2, topY);
    final topRight = Offset((size.width + shoulderWidth) / 2, topY);
    final bottomLeft = Offset((size.width - bodyWidth) / 2, bottomY);
    final bottomRight = Offset((size.width + bodyWidth) / 2, bottomY);

    final bodyPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    canvas.drawPath(bodyPath, fillPaint);
    if (isChild) {
      canvas.drawPath(bodyPath, strokePaint);
    }

    // Arms/sleeves
    final armTopY = topY + 5;
    final armBottomY = armTopY + sleeveLength;

    final leftArm = Path()
      ..moveTo(topLeft.dx, armTopY)
      ..lineTo(topLeft.dx - sleeveLength, armTopY + sleeveLength * 0.2)
      ..lineTo(topLeft.dx - sleeveLength, armBottomY)
      ..lineTo(topLeft.dx, armBottomY)
      ..close();

    final rightArm = Path()
      ..moveTo(topRight.dx, armTopY)
      ..lineTo(topRight.dx + sleeveLength, armTopY + sleeveLength * 0.2)
      ..lineTo(topRight.dx + sleeveLength, armBottomY)
      ..lineTo(topRight.dx, armBottomY)
      ..close();

    canvas.drawPath(leftArm, fillPaint);
    canvas.drawPath(rightArm, fillPaint);
    if (isChild) {
      canvas.drawPath(leftArm, strokePaint);
      canvas.drawPath(rightArm, strokePaint);
    }

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: isChild ? '体型' : '服',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - textPainter.height),
    );
  }

  @override
  bool shouldRepaint(covariant _SilhouettePainter oldDelegate) {
    return shoulderWidth != oldDelegate.shoulderWidth ||
        bodyWidth != oldDelegate.bodyWidth ||
        bodyHeight != oldDelegate.bodyHeight ||
        sleeveLength != oldDelegate.sleeveLength ||
        color != oldDelegate.color ||
        isChild != oldDelegate.isChild;
  }
}


