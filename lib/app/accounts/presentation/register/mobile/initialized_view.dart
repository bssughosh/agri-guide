import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../register_controller.dart';
import 'registration_page_1.dart';
import 'registration_page_2.dart';
import 'registration_page_3.dart';

Widget buildRegistrationInitializedView({
  @required bool isWeb,
  @required RegisterPageController controller,
  @required BuildContext context,
}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    resizeToAvoidBottomInset: false,
    floatingActionButton: isWeb
        ? FloatingActionButton(
            child: Icon(Icons.home),
            onPressed: () {
              controller.navigateToHomepage();
            },
          )
        : null,
    body: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScope),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/register_heading.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.2),
            child: Stack(
              children: [
                AutofillGroup(
                  child: PageView(
                    controller: controller.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      registrationPage1(
                          controller: controller, width: screenWidth * 0.9),
                      registrationPage2(
                          controller: controller, width: screenWidth * 0.9),
                      registrationPage3(
                          controller: controller, width: screenWidth * 0.9),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Center(
                    child: Container(
                      width: isWeb
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (controller.currentPageNumber != 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextButton.icon(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  controller.backButtonPressed();
                                },
                                label: Text('Back'),
                              ),
                            ),
                          if (controller.currentPageNumber == 0) Container(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton.icon(
                              icon: controller.currentPageNumber ==
                                      controller.lastPageNumber
                                  ? Icon(Icons.done)
                                  : Icon(Icons.arrow_forward),
                              onPressed: () {
                                if (controller.currentPageNumber ==
                                    controller.lastPageNumber)
                                  controller.submitButtonPressed();
                                else
                                  controller.nextButtonPressed();
                              },
                              label: Text(
                                controller.currentPageNumber ==
                                        controller.lastPageNumber
                                    ? 'Submit'
                                    : 'Next',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
