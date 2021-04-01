import 'package:flutter/material.dart';

import '../register_controller.dart';
import 'registration_page_2.dart';
import 'registration_page_1.dart';
import 'registration_page_3.dart';

Widget buildRegistrationInitializedView({
  @required bool isWeb,
  @required RegisterPageController controller,
  @required BuildContext context,
}) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.home),
      onPressed: () {
        controller.navigateToHomepage();
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    body: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScope),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          width: isWeb
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              AutofillGroup(
                child: PageView(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    registrationPage1(isWeb: isWeb, controller: controller),
                    registrationPage2(controller: controller),
                    registrationPage3(controller: controller),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                child: Center(
                  child: Container(
                    width: isWeb
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (controller.currentPageNumber != 0)
                          TextButton.icon(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              controller.backButtonPressed();
                            },
                            label: Text('Back'),
                          ),
                        if (controller.currentPageNumber == 0) Container(),
                        TextButton.icon(
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
  );
}
