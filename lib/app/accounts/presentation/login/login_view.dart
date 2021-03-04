import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/app_theme.dart';
import 'login_controller.dart';
import 'login_state_machine.dart';

class LoginPage extends View {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState
    extends ResponsiveViewState<LoginPage, LoginPageController> {
  LoginViewState() : super(new LoginPageController());

  @override
  void initState() {
    controller.emailText.text = '';
    controller.passwordText.text = '';
    super.initState();
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case LoginInitializationState:
        return _buildInitilizationPage();
      case LoginInitializedState:
        return _buildMobileLoginPage();
      case LoginLoadingState:
        return _buildLoadingLoginPage();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case LoginInitializationState:
        return _buildInitilizationPage();
      case LoginInitializedState:
        return _buildLoginPage();
      case LoginLoadingState:
        return _buildLoadingLoginPage();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  _buildInitilizationPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildLoadingLoginPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildMobileLoginPage() {
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
                    ColorizeAnimatedTextKit(
                      text: [
                        "AGRI GUIDE",
                      ],
                      textStyle:
                          AppTheme.loginAnimatedText.copyWith(fontSize: 30),
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                      ],
                      textAlign: TextAlign.center,
                    ),
                    TypewriterAnimatedTextKit(
                      text: [
                        "A Smart Innovative Platform for Crop Prediction",
                      ],
                      speed: Duration(milliseconds: 100),
                      pause: Duration(milliseconds: 1000),
                      textStyle: AppTheme.loginAnimatedText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
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
                                            controller.emailText.text.length !=
                                                0
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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

  _buildLoginPage() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          controller.navigateToHomepage();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Container(
          width: 500,
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/login_icon.png",
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
    );
  }
}
