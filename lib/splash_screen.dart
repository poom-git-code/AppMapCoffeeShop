import 'package:app_map_coffee_shop/screens/login_ui.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 4;
  int currentSeconds = 0;

  startTimeout(int milliseconds) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginUI()),
          );
        }
      });
    });
  }

  @override
  void initState() {
    startTimeout(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              height: hi,
              width: wi,
              color: const Color(0xffFFBD71),
            ),
            Container(
              width: wi,
              height: hi,
              child: CustomPaint(  /*ใช้ในการสร้างตัวเรขาคณิต โดยที่ต้องไปสร้าง class ใหม่*/
                painter: ShapesPainter(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/Logo_coffee_map.png',
                    width: 500.0,
                    height: 500.0,
                  ),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}


//---------------------------------------------------------
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