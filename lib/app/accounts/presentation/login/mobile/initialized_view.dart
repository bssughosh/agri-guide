import 'package:agri_guide/app/accounts/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../login_controller.dart';

Widget buildLoginInitializedViewMobile({
  @required LoginPageController controller,
  @required BuildContext context,
}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.sync(controller.onWillPopScope),
        child: AutofillGroup(
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
                        hint: 'Eamil',
                        autofillHints: [AutofillHints.username],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        title: 'Password',
                        textController: controller.passwordText,
                        onChanged: controller.updatePasswordField,
                        hint: 'Passwword',
                        autofillHints: [AutofillHints.password],
                        obscureText: true,
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
  );
}

// class BNBCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     Path path = Path()..moveTo(0, size.height * 0.3);
//     path.quadraticBezierTo(
//       size.width / 2,
//       size.height * 0.2,
//       size.width,
//       size.height * 0.3,
//     );
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.lineTo(0, size.height * 0.3);

//     canvas.drawShadow(path, Colors.black, 20, true);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
