import 'package:flutter/material.dart';

/// An entity containing statistics details
class StatisticsEntity {
  /// The list of temperature values for plotting the graph
  final List temperatureData;

  /// The list of humidity values for plotting the graph
  final List humidityData;

  /// The list of rainfall values for plotting the graph
  final List rainfallData;

  StatisticsEntity({
    @required this.temperatureData,
    @required this.humidityData,
    @required this.rainfallData,
  });
}
