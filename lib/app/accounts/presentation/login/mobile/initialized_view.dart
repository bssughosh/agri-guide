import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../login_controller.dart';

Widget buildLoginInitializedViewMobile({
  @required LoginPageController controller,
  @required BuildContext context,
}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Scaffold(
    body: SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.sync(controller.onWillPopScope),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                color: AppTheme.secondaryColor,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'assets/login_icon.png',
                      height: 130,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: CustomPaint(
                  size: Size(screenWidth, screenHeight),
                  painter: BNBCustomPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.2,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.3);

    canvas.drawShadow(path, Colors.black, 20, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
