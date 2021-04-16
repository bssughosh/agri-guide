import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/app_theme.dart';
import '../../../core/custom_icons_icons.dart';
import '../../../core/enums.dart';
import '../../dashboard/presentation/dashboard_view.dart';
import '../../downloads/presentation/downloads_view.dart';
import '../../prediction/presentation/prediction_view.dart';
import '../../profile/presentation/profile_view.dart';
import '../../statistics/presentation/statistics_view.dart';
import 'home_controller.dart';
import 'home_state_machine.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/navigation-tabs.dart';

class HomePage extends View {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ResponsiveViewState<HomePage, HomePageController> {
  HomeViewState() : super(new HomePageController());
  PageController pageController = new PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController dashboardScrollController = ScrollController();
  final ScrollController predictionScrollController = ScrollController();
  final ScrollController statisticsScrollController = ScrollController();
  final ScrollController profileScrollController = ScrollController();
  final ScrollController downloadsScrollController = ScrollController();

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case HomePageInitializationState:
        return _buildHomeInitializationView();

      case HomePageInitializedState:
        return _buildHomeInitializedViewMobile(
          dashboardScrollController: dashboardScrollController,
          predictionScrollController: predictionScrollController,
          profileScrollController: profileScrollController,
          statisticsScrollController: statisticsScrollController,
          downloadsScrollController: downloadsScrollController,
        );
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
      case HomePageInitializationState:
        return _buildHomeInitializationView();

      case HomePageInitializedState:
        return _buildHomeInitializedViewWeb(
          dashboardScrollController: dashboardScrollController,
          predictionScrollController: predictionScrollController,
          statisticsScrollController: statisticsScrollController,
          downloadsScrollController: downloadsScrollController,
        );
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  _buildHomeInitializationView() {
    controller.checkForLoginStatus();
    return Scaffold(
      body: Container(
        child: Center(
          child: SpinKitFoldingCube(color: AppTheme.secondaryColor),
        ),
      ),
    );
  }

  _buildHomeInitializedViewWeb({
    @required ScrollController dashboardScrollController,
    @required ScrollController predictionScrollController,
    @required ScrollController statisticsScrollController,
    @required ScrollController downloadsScrollController,
  }) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfilePage(),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 70,
        leadingWidth: 100,
        title: Text(
          controller.loginStatus == LoginStatus.LOGGED_OUT
              ? 'Agri Guide'
              : 'Hello, ${controller.userEntity.name}',
          style: TextStyle(color: Colors.white),
        ),
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 50,
            ),
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        actions: [
          Center(
            child: Padding(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    controller.changePageNumber(0);
                    pageController.jumpToPage(0);
                  },
                  child: NavigationTabs(
                    title: 'Dashboard',
                    condition: controller.pageNumber == 0,
                    icon: CustomIcons.home_logo,
                  ),
                ),
              ),
              padding: EdgeInsets.only(right: 20.0),
            ),
          ),
          Center(
            child: Padding(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    controller.changePageNumber(1);
                    pageController.jumpToPage(1);
                  },
                  child: NavigationTabs(
                    title: 'Downloads',
                    condition: controller.pageNumber == 1,
                    icon: CustomIcons.downloads_logo,
                  ),
                ),
              ),
              padding: EdgeInsets.only(right: 20.0),
            ),
          ),
          Center(
            child: Padding(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    controller.changePageNumber(2);
                    pageController.jumpToPage(2);
                  },
                  child: NavigationTabs(
                    title: 'Statistics',
                    condition: controller.pageNumber == 2,
                    icon: CustomIcons.statistics_logo,
                  ),
                ),
              ),
              padding: EdgeInsets.only(right: 20.0),
            ),
          ),
          Center(
            child: Padding(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    controller.changePageNumber(3);
                    pageController.jumpToPage(3);
                  },
                  child: NavigationTabs(
                    title: 'Prediction',
                    condition: controller.pageNumber == 3,
                    icon: CustomIcons.prediction_logo,
                  ),
                ),
              ),
              padding: EdgeInsets.only(right: 20.0),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _dashboardPage(dashboardScrollController),
            _downloadsPage(downloadsScrollController),
            _statisticsPage(statisticsScrollController),
            _predictionPage(predictionScrollController),
          ],
        ),
      ),
    );
  }

  _buildHomeInitializedViewMobile({
    @required ScrollController dashboardScrollController,
    @required ScrollController predictionScrollController,
    @required ScrollController statisticsScrollController,
    @required ScrollController downloadsScrollController,
    @required ScrollController profileScrollController,
  }) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        controller: controller,
        pageController: pageController,
      ),
      appBar: AppBar(
        toolbarHeight: 106,
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app_bar_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Agri\nGuide',
          style: AppTheme.headingBoldText.copyWith(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _dashboardPage(dashboardScrollController),
            _downloadsPage(downloadsScrollController),
            _predictionPage(predictionScrollController),
            _statisticsPage(statisticsScrollController),
            _mobileProfilePage(profileScrollController),
          ],
        ),
      ),
    );
  }

  Widget _dashboardPage(ScrollController scrollController) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RawScrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          thumbColor: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                DashboardPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _downloadsPage(ScrollController scrollController) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RawScrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          thumbColor: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                DownloadsPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statisticsPage(ScrollController scrollController) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RawScrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          thumbColor: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                StatisticsPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _predictionPage(ScrollController scrollController) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RawScrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          thumbColor: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                PredictionPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileProfilePage(ScrollController scrollController) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RawScrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          thumbColor: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                ProfilePage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
