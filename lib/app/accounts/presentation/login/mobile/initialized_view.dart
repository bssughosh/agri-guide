import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../login_controller.dart';

Widget buildLoginInitializedViewMobile({
  @required LoginPageController controller,
  @required BuildContext context,
}) {
  double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    body: SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.sync(controller.onWillPopScope),
        child: AutofillGroup(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/login_heading1.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.5),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CustomTextField(
                          title: 'Email',
                          textController: controller.emailText,
                          onChanged: controller.updateEmailField,
                          hint: 'Email',
                          autofillHints: [AutofillHints.username],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: 'Password',
                          textController: controller.passwordText,
                          onChanged: controller.updatePasswordField,
                          hint: 'Password',
                          autofillHints: [AutofillHints.password],
                          obscureText: true,
                          onSaved: controller.loginUser,
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          isActive: controller.emailText.text.length > 0 &&
                              controller.passwordText.text.length > 0,
                          isOverlayRequired: false,
                          onPressed: () {
                            controller.loginUser();
                          },
                          title: 'Login',
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('New User?'),
                                SizedBox(width: 10),
                                GestureDetector(
                                  child: Text(
                                    'Register',
                                    style: AppTheme.bodyBoldText.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppTheme.secondaryColor,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.navigateToRegistration();
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
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
