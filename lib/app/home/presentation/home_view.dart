import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/app_theme.dart';
import '../../accounts/domain/repositories/firebase_authentication_repository.dart';
import '../../downloads/presentation/downloads_view.dart';
import '../../prediction/presentation/prediction_view.dart';
import '../../statistics/presentation/statistics_view.dart';
import 'home_controller.dart';
import 'home_state_machine.dart';
import 'widgets/navigation-tabs.dart';

class HomePage extends View {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ResponsiveViewState<HomePage, HomePageController> {
  HomeViewState() : super(new HomePageController());
  PageController pageController = new PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case HomePageInitializationState:
        return _buildLoadingPage();

      case HomePageInitializedState:
        return _buildBottomBar();
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
        return _buildLoadingPage();

      case HomePageInitializedState:
        return _buildAppBar();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  _buildLoadingPage() {
    controller.checkForLoginStatus();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildAppBar() {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/icon.png',
              width: 70,
            ),
            Text(
              'Agri Guide',
              style: AppTheme.bodyBoldText,
            ),
            SizedBox(height: 30),
            if (controller.loginStatus == LoginStatus.LOGGED_OUT)
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
            if (controller.loginStatus == LoginStatus.LOGGED_IN)
              Text(
                'Welcome, ${controller.userEntity.name}',
                style: AppTheme.bodyBoldText,
              ),
            SizedBox(height: 30),
            if (controller.loginStatus == LoginStatus.LOGGED_IN)
              FlatButton(
                child: Text(
                  'Logout',
                  style: AppTheme.navigationTabSelectedTextStyle,
                ),
                color: AppTheme.navigationSelectedColor,
                onPressed: () {
                  controller.logoutUser();
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 70,
        leadingWidth: 100,
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
                    title: 'Downloads',
                    condition: controller.pageNumber == 0,
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
                    title: 'Statistics',
                    condition: controller.pageNumber == 1,
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
                    title: 'Prediction',
                    condition: controller.pageNumber == 2,
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
            _downloadsPage(),
            _statisticsPage(),
            _predictionPage(),
          ],
        ),
      ),
    );
  }

  _buildBottomBar() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agri Guide'),
        backgroundColor: AppTheme.primaryColor,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: AppTheme.navigationSelectedColor,
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.get_app, title: 'Downloads'),
          TabItem(icon: Icons.insights, title: 'Statistics'),
          TabItem(icon: Icons.schedule, title: 'Prediction'),
          TabItem(icon: Icons.account_circle, title: 'Account'),
        ],
        initialActiveIndex: 0,
        onTap: (int i) {
          controller.changePageNumber(i);
          pageController.jumpToPage(i);
        },
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _downloadsPage(),
            _statisticsPage(),
            _predictionPage(),
            _mobileProfilePage(),
          ],
        ),
      ),
    );
  }

  Widget _downloadsPage() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DownloadsPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statisticsPage() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StatisticsPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _predictionPage() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PredictionPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileProfilePage() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/icon.png',
                width: 70,
              ),
              Text(
                'Agri Guide',
                style: AppTheme.bodyBoldText,
              ),
              SizedBox(height: 30),
              if (controller.loginStatus == LoginStatus.LOGGED_OUT)
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
              if (controller.loginStatus == LoginStatus.LOGGED_IN)
                Text(
                  'Welcome, ${controller.userEntity.name}',
                  style: AppTheme.bodyBoldText,
                ),
              SizedBox(height: 30),
              if (controller.loginStatus == LoginStatus.LOGGED_IN)
                FlatButton(
                  child: Text(
                    'Logout',
                    style: AppTheme.navigationTabSelectedTextStyle,
                  ),
                  color: AppTheme.navigationSelectedColor,
                  onPressed: () {
                    controller.logoutUser();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
