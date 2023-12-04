import 'package:flutter/material.dart';

import '../../values/app_colors.dart';

class ReceiverCustomPainter extends CustomPainter {

  ReceiverCustomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.appRedButtonColorDisable
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    //a polygon 📐
    var path = Path();
    path.lineTo(0, 6);
    path.lineTo(-10, 6);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}