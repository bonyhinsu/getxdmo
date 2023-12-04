import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportCustomPaint extends CustomPainter{
  final double height;
  final double width;
  final Color fillColor;
  final double radius;

  SportCustomPaint({
    this.height= 70.0,
    this.width= 300.0,
    this.fillColor= Colors.white,
    this.radius= 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    paint.color = Colors.green;
    paint.style = PaintingStyle.fill;

    path.moveTo(0, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.400,
        size.width * 0.5, size.height * 0.9167);

    path.quadraticBezierTo(size.width * 0.55, size.height * 0.400,
        size.width * 1.0, size.height * 0.1);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);

    var blackPaint = Paint();
    blackPaint.color = Colors.black;
    var path2 = Path();
    path2.moveTo(size.width/2, size.height);
    path2.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    canvas.drawPath(path2, blackPaint);

    // Path path = new Path();
    // path.moveTo(0.0, -radius);
    // path.lineTo(0.0, -(height - radius));
    // path.conicTo(0.0, -height, radius, -height, 1);
    // path.lineTo(width - radius, -height);
    // path.conicTo(width, -height, width, -(height + radius), 1);
    // path.lineTo(width, -(height - radius));
    // path.lineTo(width, -radius);
    //
    // path.conicTo(width, 0.0, width - radius, 0.0, 1);
    // path.lineTo(radius, 0.0);
    // path.conicTo(0.0, 0.0, 0.0, -radius, 1);
    // path.close();
    // canvas.drawPath(path, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}