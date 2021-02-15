import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/app_theme.dart';
import '../../accounts/domain/repositories/firebase_authentication_repository.dart';
import '../../downloads/presentation/downloads_controller.dart';
import 'prediction_controller.dart';
import 'prediction_state_machine.dart';
import 'widgets/custom_table.dart';
import 'widgets/location_selection_bar.dart';
import 'widgets/location_selection_card.dart';
import 'widgets/prediction_range_mobile_widget.dart';
import 'widgets/prediction_range_widget.dart';
import 'widgets/season_and_crop_mobile_widget.dart';
import 'widgets/season_and_crop_widget.dart';

class PredictionPage extends View {
  @override
  State<StatefulWidget> createState() => PredictionViewState();
}

class PredictionViewState
    extends ResponsiveViewState<PredictionPage, PredictionPageController> {
  PredictionViewState() : super(new PredictionPageController());

  @override
  void initState() {
    controller.startMonth = controller.months[0];
    controller.endMonth = controller.months[1];
    super.initState();
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case PredictionPageInitializationState:
        return _buildInitState();
      case PredictionPageInitializedState:
        return _buildPredictionPage(false);
      case PredictionPageLoadingState:
        return _buildLoadingPage();
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
      case PredictionPageInitializationState:
        return _buildInitState();
      case PredictionPageInitializedState:
        return _buildPredictionPage(true);
      case PredictionPageLoadingState:
        return _buildLoadingPage();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  Widget _buildInitState() {
    controller.checkForLoginStatus();
    return Container(
      child: Center(
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget _buildPredictionPage(bool isWeb) {
    if (controller.loginStatus == LoginStatus.LOGGED_OUT) {
      return Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'You Must Login to get predictions for your location',
                  style: AppTheme.headingBoldText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                FlatButton(
                  child: Text(
                    'Login / Register',
                    style: AppTheme.navigationTabSelectedTextStyle,
                  ),
                  color: AppTheme.navigationSelectedColor,
                  onPressed: () {
                    controller.navigateToLogin();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _contentBody(isWeb);
  }

  Widget _contentBody(bool isWeb) {
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
                child: predictionPage1(isWeb),
              ),
              WillPopScope(
                onWillPop: () => Future.sync(controller.onWillPopScopePage2),
                child: predictionPage2(isWeb),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget predictionPage1(bool isWeb) {
    if (!controller.stateListInitialized) controller.fetchStateList();
    return Container(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: isWeb
                  ? MediaQuery.of(context).size.width / 3
                  : MediaQuery.of(context).size.width,
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
                    if (controller.areCropsAvailable &&
                        (controller.seasonListLoading ||
                            controller.cropListLoading))
                      CircularProgressIndicator(),
                    if (controller.areCropsAvailable &&
                        (!controller.seasonListLoading &&
                            !controller.cropListLoading))
                      isWeb
                          ? SeasonAndCropWidget(controller: controller)
                          : SeasonAndCropMobileWidget(controller: controller),
                    if (controller.selectedState != '' &&
                        controller.selectedDistrict != '' &&
                        (controller.areCropsAvailable
                            ? (controller.selectedCrop != null &&
                                controller.selectedSeason != null)
                            : true))
                      Center(
                        child: isWeb
                            ? PredictionRangeWidget(
                                controller: controller,
                              )
                            : PredictionRangeMobileWidget(
                                controller: controller,
                              ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (controller.selectedState != '' &&
                        controller.selectedDistrict != '' &&
                        (controller.areCropsAvailable
                            ? (controller.selectedCrop != null &&
                                controller.selectedSeason != null)
                            : true))
                      Center(
                        child: FlatButton(
                          child: Text(
                            'Submit',
                            style: AppTheme.navigationTabSelectedTextStyle,
                          ),
                          color: AppTheme.navigationSelectedColor,
                          hoverColor: AppTheme.secondaryColor,
                          onPressed: () {
                            controller.proceedToPrediction(1);
                          },
                        ),
                      )
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

  Widget predictionPage2(bool isWeb) {
    return Container(
      width: isWeb
          ? MediaQuery.of(context).size.width / 3
          : MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            if (controller.isPredicting) CircularProgressIndicator(),
            if (!controller.isPredicting && controller.temperature.length > 0)
              CustomTable(
                controller: controller,
                tableType: TableType.TEMPERATURE,
                isWeb: isWeb,
              ),
            SizedBox(height: 15),
            if (!controller.isPredicting && controller.humidity.length > 0)
              CustomTable(
                controller: controller,
                tableType: TableType.HUMIDITY,
                isWeb: isWeb,
              ),
            SizedBox(height: 15),
            if (!controller.isPredicting && controller.rainfall.length > 0)
              CustomTable(
                controller: controller,
                tableType: TableType.RAINFALL,
                isWeb: isWeb,
              ),
            SizedBox(height: 15),
            if (!controller.isPredicting && controller.predictedYield != -1)
              Center(
                child: Container(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'YIELD PREDICTION',
                          style: AppTheme.headingBoldText,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'SEASON: ' + controller.selectedSeason,
                          style: AppTheme.headingRegularText,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'CROP: ' +
                              controller.getCropNameFromCropId(
                                  controller.selectedCrop),
                          style: AppTheme.headingRegularText,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'PREDICTED YIELD: ' +
                              controller.calculatePersonalisedYield() +
                              ' quintals',
                          style: AppTheme.headingRegularText,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return Container(
      child: Center(
        child: LinearProgressIndicator(),
      ),
    );
  }
}
