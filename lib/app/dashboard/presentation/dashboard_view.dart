import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'dashboard_controller.dart';

class DashboardPage extends View {
  @override
  State<StatefulWidget> createState() => DashboardViewState();
}

class DashboardViewState
    extends ResponsiveViewState<DashboardPage, DashboardPageController> {
  DashboardViewState() : super(new DashboardPageController());

  @override
  Widget buildMobileView() {
    // TODO: implement buildMobileView
    throw UnimplementedError();
  }

  @override
  Widget buildTabletView() {
    // TODO: implement buildTabletView
    throw UnimplementedError();
  }

  @override
  Widget buildDesktopView() {
    // TODO: implement buildDesktopView
    throw UnimplementedError();
  }
}
