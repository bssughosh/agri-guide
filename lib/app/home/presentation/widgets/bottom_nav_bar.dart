import 'package:agri_guide/core/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../core/custom_icons_icons.dart';
import '../home_controller.dart';
import 'bottom_nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final HomePageController controller;
  final PageController pageController;

  const BottomNavBar({
    @required this.controller,
    @required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 110,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(size.width, 90),
              painter: BNBCustomPainter(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 70,
                    child: BottomNavBarItem(
                      icon: CustomIcons.home_logo,
                      isSelected: controller.pageNumber == 0,
                      onPressed: () {
                        pageController.jumpToPage(0);
                        controller.changePageNumber(0);
                      },
                      title: 'Dashboard',
                    ),
                  ),
                  Container(
                    width: 70,
                    child: BottomNavBarItem(
                      icon: CustomIcons.downloads_logo,
                      isSelected: controller.pageNumber == 1,
                      onPressed: () {
                        pageController.jumpToPage(1);
                        controller.changePageNumber(1);
                      },
                      title: 'Downloads',
                    ),
                  ),
                  Container(width: 80),
                  Container(
                    width: 70,
                    child: BottomNavBarItem(
                      icon: CustomIcons.statistics_logo,
                      isSelected: controller.pageNumber == 3,
                      onPressed: () {
                        pageController.jumpToPage(3);
                        controller.changePageNumber(3);
                      },
                      title: 'Statistics',
                    ),
                  ),
                  Container(
                    width: 70,
                    child: BottomNavBarItem(
                      icon: CustomIcons.accounts_logo,
                      isSelected: controller.pageNumber == 4,
                      onPressed: () {
                        pageController.jumpToPage(4);
                        controller.changePageNumber(4);
                      },
                      title: 'Accounts',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  child: Icon(
                    CustomIcons.prediction_logo,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    pageController.jumpToPage(2);
                    controller.changePageNumber(2);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Text(
                    'Prediction',
                    style: TextStyle(
                      color: controller.pageNumber == 2
                          ? AppTheme.secondaryColor
                          : Colors.black,
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
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, 20);
    path.lineTo(size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);

    canvas.drawShadow(path, Colors.black, 20, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
