import '../entities/statistics_entity.dart';

abstract class StatisticsRepository {
  /// A function to fetch whole data for plotting the graph
  Future<StatisticsEntity> fetchWholeData(String state, String district);
}
