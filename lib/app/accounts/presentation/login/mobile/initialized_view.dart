import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../login_controller.dart';

Widget buildLoginInitializedViewMobile({
  @required LoginPageController controller,
  @required BuildContext context,
}) {
  double screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
    backgroundColor: AppTheme.loginBackground,
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.sync(controller.onWillPopScope),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: AutofillGroup(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.25),
                    Image.asset(
                      'assets/login_icon.png',
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Agri Guide',
                      style: AppTheme.headingBoldText
                          .copyWith(fontSize: 19, color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller.emailText,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.portrait),
                              labelText: 'Email',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: UnderlineInputBorder(),
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
                              labelText: 'Password',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: UnderlineInputBorder(),
                            ),
                            onChanged: (value) {
                              controller.updatePasswordField(value);
                            },
                            autofillHints: [AutofillHints.password],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    isOverlayRequired: false,
                                    isActive: true,
                                    title: 'Login',
                                    onPressed: () {
                                      controller.loginUser();
                                    },
                                  ),
                                  SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () {
                                      controller.navigateToRegistration();
                                    },
                                    child: Text(
                                      'Register',
                                      style: AppTheme.buttonActiveTextStyle
                                          .copyWith(
                                              color: AppTheme
                                                  .navigationSelectedColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
