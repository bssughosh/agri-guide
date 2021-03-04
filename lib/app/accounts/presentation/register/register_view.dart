import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/app_theme.dart';
import '../../../downloads/presentation/downloads_controller.dart';
import 'register_controller.dart';
import 'register_state_machine.dart';
import 'widgets/location_selection_bar.dart';
import 'widgets/location_selection_card.dart';

class RegisterPage extends View {
  @override
  State<StatefulWidget> createState() => RegisterViewState();
}

class RegisterViewState
    extends ResponsiveViewState<RegisterPage, RegisterPageController> {
  RegisterViewState() : super(new RegisterPageController());

  @override
  void initState() {
    controller.emailText.text = '';
    controller.aadharText.text = '';
    controller.phoneText.text = '';
    controller.nameText.text = '';
    controller.areaText.text = '';
    controller.pass1Text.text = '';
    controller.pass2Text.text = '';
    super.initState();
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case RegisterInitializedState:
        return _buildRegistrationPages(false);
      case RegisterLoadingState:
        return _buildLoadingRegisterPage();
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
      case RegisterInitializedState:
        return _buildRegistrationPages(true);
      case RegisterLoadingState:
        return _buildLoadingRegisterPage();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  _buildRegistrationPages(bool isWeb) {
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
                    registrationPage1(),
                    registrationPage2(isWeb),
                    registrationPage3(),
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
    );
  }

  _buildLoadingRegisterPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget registrationPage1() {
    // name, email, phone, aadhar
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Personal Details',
                  style: AppTheme.headingBoldText,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controller.nameText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Full Name',
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
                autofillHints: [AutofillHints.name],
              ),
              SizedBox(height: 5),
              TextField(
                controller: controller.emailText,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  errorText: controller.isEmailTextFine
                      ? null
                      : 'Please enter a valid email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
                autofillHints: [AutofillHints.newUsername],
              ),
              SizedBox(height: 5),
              TextField(
                controller: controller.aadharText,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Aadhar Card Number',
                  labelText: 'Aadhar Card Number',
                  errorText: controller.isAadharTextFine
                      ? null
                      : 'Please enter an Aadhar card number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
              ),
              SizedBox(height: 5),
              TextField(
                controller: controller.phoneText,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Mobile Number (optional)',
                  labelText: 'Mobile Number',
                  errorText: controller.isPhoneTextFine
                      ? null
                      : 'Please enter a valid mobile number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
                autofillHints: [AutofillHints.telephoneNumber],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget registrationPage2(bool isWeb) {
    // state, dist, area
    if (!controller.stateListInitialized) controller.fetchStateList();
    return Container(
      child: Stack(
        children: [
          Center(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Agricultural Location Details',
                        style: AppTheme.headingBoldText,
                      ),
                    ),
                    SizedBox(height: 15),
                    if (controller.stateListLoading)
                      CircularProgressIndicator(),
                    if (!controller.stateListLoading)
                      LocationSelectionBar(
                        controller: controller,
                        selectionListType: SelectionListType.STATE,
                        isWeb: isWeb,
                      ),
                    if (!controller.stateListLoading &&
                        controller.selectedState != '')
                      if (controller.districtListLoading)
                        CircularProgressIndicator(),
                    if (!controller.stateListLoading &&
                        controller.selectedState != '')
                      if (!controller.districtListLoading)
                        LocationSelectionBar(
                          controller: controller,
                          selectionListType: SelectionListType.DISTRICT,
                          isWeb: isWeb,
                        ),
                    if (controller.selectedState != '' &&
                        controller.selectedDistrict != '')
                      TextField(
                        controller: controller.areaText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Area of the plot (acres)',
                          labelText: 'Area (acres)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onChanged: (value) {
                          controller.textFieldChanged();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isStateFilterClicked)
            Center(
              child: LocationSelectionCard(
                controller: controller,
                selectionListType: SelectionListType.STATE,
                isWeb: isWeb,
              ),
            ),
          if (controller.isDistrictFilterClicked)
            Center(
              child: LocationSelectionCard(
                controller: controller,
                selectionListType: SelectionListType.DISTRICT,
                isWeb: isWeb,
              ),
            ),
        ],
      ),
    );
  }

  Widget registrationPage3() {
    // pass, confirm pass
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Login Credentials',
                  style: AppTheme.headingBoldText,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controller.pass1Text,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  errorText: controller.doBothPassMatch
                      ? null
                      : 'Both the passwords should match',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
                autofillHints: [AutofillHints.newPassword],
              ),
              SizedBox(height: 5),
              TextField(
                controller: controller.pass2Text,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password',
                  errorText: controller.doBothPassMatch
                      ? null
                      : 'Both the passwords should match',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  controller.textFieldChanged();
                },
                autofillHints: [AutofillHints.newPassword],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
