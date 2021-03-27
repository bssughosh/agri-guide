import 'package:agri_guide/app/statistics/domain/entities/yield_statistics_entity.dart';

import '../entities/statistics_entity.dart';

abstract class StatisticsRepository {
  /// A function to fetch whole data for plotting the graph
  Future<StatisticsEntity> fetchWholeData(String state, String district);

  /// A function to fetch production/area data for a crop
  /// in a particular for plotting the graph
  Future<YieldStatisticsEntity> fetchYieldStatisticsData(
      String state, String district, String cropId, String season);
}
