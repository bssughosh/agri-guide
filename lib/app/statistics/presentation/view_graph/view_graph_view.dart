import 'package:agri_guide/app/statistics/presentation/view_graph/view_graph_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ViewGraphPage extends View {
  @override
  State<StatefulWidget> createState() => ViewGraphViewState();
}

class ViewGraphViewState
    extends ResponsiveViewState<ViewGraphPage, ViewGraphPageController> {
  ViewGraphViewState() : super(new ViewGraphPageController());

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
