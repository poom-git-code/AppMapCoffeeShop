import 'dart:ui';
import 'package:flutter/cupertino.dart';

class ShapesPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint(); /*ใช้ระบานสี*/
    var path = Path(); /*ใช้ในการกำหนดจุด*/
    path.lineTo(0, size.height * 1.0);
    path.lineTo(size.width * 1.0, 0);
    paint.color = const Color(0xffFFB35C);
    canvas.drawPath(path, paint);
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //throw UnimplementedError();
    return false;
  }

}