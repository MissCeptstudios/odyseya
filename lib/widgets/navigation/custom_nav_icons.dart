import 'package:flutter/material.dart';

/// Custom painted navigation icons matching the design inspiration
class CustomNavIcons {
  /// Inspire icon - Sunrise with horizon line
  static Widget inspire(Color color, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InspireIconPainter(color),
    );
  }

  /// Express icon - Microphone
  static Widget express(Color color, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ExpressIconPainter(color),
    );
  }

  /// Reflect icon - Brain
  static Widget reflect(Color color, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ReflectIconPainter(color),
    );
  }

  /// Renew icon - Leaf
  static Widget renew(Color color, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RenewIconPainter(color),
    );
  }
}

/// Inspire icon painter - Sunrise with rays and horizon
class _InspireIconPainter extends CustomPainter {
  final Color color;

  _InspireIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height * 0.6);
    final radius = size.width * 0.2;

    // Draw semi-circle (sun)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14, // π (180 degrees)
      3.14, // π (180 degrees) - draws top half
      false,
      paint,
    );

    // Draw horizon line
    canvas.drawLine(
      Offset(size.width * 0.15, center.dy),
      Offset(size.width * 0.85, center.dy),
      paint,
    );

    // Draw sun rays
    final rayLength = size.width * 0.12;

    // Top ray
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy - radius - rayLength),
      paint,
    );

    // Left ray
    canvas.drawLine(
      Offset(center.dx - radius * 0.7, center.dy - radius * 0.7),
      Offset(center.dx - radius * 0.7 - rayLength * 0.7, center.dy - radius * 0.7 - rayLength * 0.7),
      paint,
    );

    // Right ray
    canvas.drawLine(
      Offset(center.dx + radius * 0.7, center.dy - radius * 0.7),
      Offset(center.dx + radius * 0.7 + rayLength * 0.7, center.dy - radius * 0.7 - rayLength * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Express icon painter - Microphone
class _ExpressIconPainter extends CustomPainter {
  final Color color;

  _ExpressIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final micWidth = size.width * 0.25;
    final micHeight = size.height * 0.35;
    final micTop = size.height * 0.2;

    // Draw microphone capsule
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, micTop + micHeight / 2),
        width: micWidth,
        height: micHeight,
      ),
      Radius.circular(micWidth / 2),
    );
    canvas.drawRRect(micRect, paint);

    // Draw microphone base arc
    final arcRect = Rect.fromCenter(
      center: Offset(centerX, micTop + micHeight + size.height * 0.12),
      width: micWidth * 1.8,
      height: size.height * 0.25,
    );
    canvas.drawArc(
      arcRect,
      3.14, // π
      3.14, // π - draws bottom arc
      false,
      paint,
    );

    // Draw microphone stand
    canvas.drawLine(
      Offset(centerX, micTop + micHeight + size.height * 0.22),
      Offset(centerX, size.height * 0.85),
      paint,
    );

    // Draw microphone base
    canvas.drawLine(
      Offset(centerX - micWidth * 0.6, size.height * 0.85),
      Offset(centerX + micWidth * 0.6, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reflect icon painter - Brain
class _ReflectIconPainter extends CustomPainter {
  final Color color;

  _ReflectIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw brain outline (simplified)
    final path = Path();

    // Left hemisphere
    path.moveTo(centerX - size.width * 0.05, centerY - size.height * 0.3);
    path.cubicTo(
      centerX - size.width * 0.35, centerY - size.height * 0.3,
      centerX - size.width * 0.35, centerY + size.height * 0.3,
      centerX - size.width * 0.05, centerY + size.height * 0.3,
    );

    // Right hemisphere
    path.moveTo(centerX + size.width * 0.05, centerY - size.height * 0.3);
    path.cubicTo(
      centerX + size.width * 0.35, centerY - size.height * 0.3,
      centerX + size.width * 0.35, centerY + size.height * 0.3,
      centerX + size.width * 0.05, centerY + size.height * 0.3,
    );

    // Draw center division
    path.moveTo(centerX, centerY - size.height * 0.25);
    path.lineTo(centerX, centerY + size.height * 0.25);

    // Add some brain texture/folds
    path.moveTo(centerX - size.width * 0.25, centerY - size.height * 0.1);
    path.quadraticBezierTo(
      centerX - size.width * 0.15, centerY,
      centerX - size.width * 0.25, centerY + size.height * 0.1,
    );

    path.moveTo(centerX + size.width * 0.25, centerY - size.height * 0.1);
    path.quadraticBezierTo(
      centerX + size.width * 0.15, centerY,
      centerX + size.width * 0.25, centerY + size.height * 0.1,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Renew icon painter - Leaf
class _RenewIconPainter extends CustomPainter {
  final Color color;

  _RenewIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Leaf outline
    path.moveTo(size.width * 0.5, size.height * 0.15);

    // Right side of leaf
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.35,
      size.width * 0.5, size.height * 0.85,
    );

    // Left side of leaf
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.35,
      size.width * 0.5, size.height * 0.15,
    );

    canvas.drawPath(path, paint);

    // Draw leaf vein (center line)
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.85),
      paint,
    );

    // Draw small side veins
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.65, size.height * 0.45),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.35, size.height * 0.45),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.62, size.height * 0.62),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.38, size.height * 0.62),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
