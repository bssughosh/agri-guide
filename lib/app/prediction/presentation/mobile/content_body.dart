import 'package:flutter/material.dart';

import '../prediction_controller.dart';
import 'prediction_page_1.dart';
import 'prediction_page_2.dart';

Widget contentBody({
  @required bool isWeb,
  @required BuildContext context,
  @required PredictionPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Center(
      child: Container(
        child: PageView(
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            WillPopScope(
              onWillPop: () => Future.sync(controller.onWillPopScopePage1),
              child: predictionPage1(
                isWeb: isWeb,
                context: context,
                controller: controller,
              ),
            ),
            WillPopScope(
              onWillPop: () => Future.sync(controller.onWillPopScopePage2),
              child: predictionPage2(
                isWeb: isWeb,
                context: context,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
