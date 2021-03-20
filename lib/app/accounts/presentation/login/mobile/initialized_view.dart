import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../login_controller.dart';

Widget buildLoginInitializedViewMobile({
  @required LoginPageController controller,
}) {
  return Scaffold(
    body: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScope),
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/login_icon.png',
                    height: 100,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: controller.emailText,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.portrait),
                      hintText: 'Email ID',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (value) {
                      controller.updateEmailField(value);
                    },
                    autofillHints: [AutofillHints.username],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.passwordText,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (value) {
                      controller.updatePasswordField(value);
                    },
                    autofillHints: [AutofillHints.password],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text(
                              'Login',
                              style: AppTheme.navigationTabSelectedTextStyle,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  controller.passwordText.text.length != 0 &&
                                          controller.emailText.text.length != 0
                                      ? MaterialStateProperty.all<Color>(
                                          AppTheme.buttonActiveColor)
                                      : MaterialStateProperty.all<Color>(
                                          AppTheme.buttonDeactiveColor),
                            ),
                            onPressed: () {
                              if (controller.passwordText.text.length != 0 &&
                                  controller.emailText.text.length != 0)
                                controller.loginUser();
                            },
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            child: Text(
                              'Register',
                              style: AppTheme.navigationTabSelectedTextStyle,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.navigationSelectedColor),
                            ),
                            onPressed: () {
                              controller.navigateToRegistration();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
