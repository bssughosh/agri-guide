import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/enums.dart';
import '../../../core/handle_api_errors.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import '../domain/entities/statistics_entity.dart';
import '../domain/entities/yield_statistics_entity.dart';
import 'statistics_presenter.dart';
import 'statistics_state_machine.dart';
import 'statistics_view.dart';
import 'view_graph/view_graph_view.dart';
import 'widgets/show_my_crop_dialog.dart';
import 'widgets/show_my_season_dialog.dart';

class StatisticsPageController extends Controller {
  final StatisticsPagePresenter _presenter;
  final StatisticsPageStateMachine _stateMachine =
      new StatisticsPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();

  StatisticsPageController()
      : _presenter = serviceLocator<StatisticsPagePresenter>(),
        super();

  List stateList = [];
  List districtList = [];
  List cropList = [];
  List seasonList = [];
  bool isStateFilterClicked = false;
  bool isDistrictFilterClicked = false;
  String selectedState;
  String selectedDistrict;
  String selectedCrop;
  String selectedSeason;
  bool districtListLoading = false;
  bool seasonListLoading = false;
  bool cropListLoading = false;
  bool areCropsAvailable = true;

  StatisticsEntity statisticsEntity;
  YieldStatisticsEntity yieldStatisticsEntity;
  List<ChartData> rainfallChartData = [];
  List<ChartData> temperatureChartData = [];
  List<ChartData> humidityChartData = [];
  List<ChartData> yieldChartData = [];

  int temperatureFirstYear;
  int humidityFirstYear;
  int rainfallFirstYear;
  int yieldFirstYear;

  List<StatisticsFilters> selectedFilters = [];

  StatisticsFilters selectedFilters1;
  StatisticsFilters selectedFilters2;

  @override
  void initListeners() {}

  StatisticsState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  // API Calls

  void fetchStateList() {
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {
          print('State list successfully fetched');
        },
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List stateListRes) {
          stateList = stateListRes;
          _stateMachine.onEvent(new StatisticsPageInputInitializedEvent());
          refreshUI();
        },
      ),
    );
  }

  void fetchDistrictList() {
    districtListLoading = true;
    refreshUI();
    _presenter.fetchDistrictList(
      new UseCaseObserver(
        () {
          print('District list successfully fetched');
        },
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List districtListRes) {
          districtList = districtListRes;
          districtListLoading = false;
          refreshUI();
        },
      ),
      selectedState,
    );
  }

  void proceedToStatisticsDisplay() {
    _stateMachine.onEvent(new StatisticsPageLoadingEvent());
    refreshUI();
    _presenter.fetchWholeData(
      new UseCaseObserver(() {
        print('Whole data fetched');
      }, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (StatisticsEntity entity) {
        statisticsEntity = entity;

        findColorsAndToChartData(
          filter: StatisticsFilters.Rainfall,
          statisticsData: statisticsEntity.rainfallData,
        );
        findColorsAndToChartData(
          filter: StatisticsFilters.Temperature,
          statisticsData: statisticsEntity.temperatureData,
        );
        findColorsAndToChartData(
          filter: StatisticsFilters.Humidity,
          statisticsData: statisticsEntity.humidityData,
        );

        if (rainfallChartData.length > 0) {
          rainfallChartData.sort((a, b) => a.x.compareTo(b.x));
          rainfallFirstYear = int.parse(rainfallChartData[0].x);
        }

        if (temperatureChartData.length > 0) {
          temperatureChartData.sort((a, b) => a.x.compareTo(b.x));
          temperatureFirstYear = int.parse(temperatureChartData[0].x);
        }

        if (humidityChartData.length > 0) {
          humidityChartData.sort((a, b) => a.x.compareTo(b.x));
          humidityFirstYear = int.parse(humidityChartData[0].x);
        }

        _stateMachine.onEvent(new StatisticsPageDisplayInitializedEvent());
        refreshUI();
      }),
      selectedState,
      selectedDistrict,
    );
  }

  void fetchCropsList(BuildContext context) {
    _stateMachine.onEvent(new StatisticsPageLoadingEvent());
    refreshUI();
    _presenter.fetchCropList(
      new UseCaseObserver(
        () {
          print('Crops list successfully fetched');
        },
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List cropsRes) {
          cropList = cropsRes;
          if (cropList.length == 0) {
            areCropsAvailable = false;
            _stateMachine.onEvent(new StatisticsPageDisplayInitializedEvent());
            refreshUI();
          } else {
            _stateMachine.onEvent(new StatisticsPageDisplayInitializedEvent());
            refreshUI();
            showMyCropDialog(
                    context: context, cropList: cropList, controller: this)
                .then((value) {
              fetchSeasonList(context);
            });
          }
        },
      ),
      selectedState,
      selectedDistrict,
    );
  }

  void fetchSeasonList(BuildContext context) {
    _stateMachine.onEvent(new StatisticsPageLoadingEvent());
    refreshUI();
    _presenter.fetchSeasonsList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List seasonsRes) {
          seasonList = seasonsRes;
          _stateMachine.onEvent(new StatisticsPageDisplayInitializedEvent());
          if (seasonList.length == 1) {
            selectedSeason = seasonList[0];
            fetchYieldStatistics();
          } else {
            showMySeasonDialog(
                    context: context, seasonsList: seasonList, controller: this)
                .then((value) {
              fetchYieldStatistics();
            });
          }

          refreshUI();
        },
      ),
      selectedState,
      selectedDistrict,
      selectedCrop,
    );
  }

  void fetchYieldStatistics() {
    _stateMachine.onEvent(new StatisticsPageLoadingEvent());
    refreshUI();

    _presenter.fetchYieldStatistics(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (YieldStatisticsEntity yieldStats) {
        yieldStatisticsEntity = yieldStats;

        findColorsAndToChartData(
          filter: StatisticsFilters.Yield,
          statisticsData: yieldStatisticsEntity.yieldData,
        );

        if (yieldChartData.length > 0) {
          yieldChartData.sort((a, b) => a.x.compareTo(b.x));
          yieldFirstYear = int.parse(yieldChartData[0].x);
        }

        _stateMachine.onEvent(new StatisticsPageDisplayInitializedEvent());

        onFilterClicked(StatisticsFilters.Yield);
        refreshUI();
      }),
      selectedState,
      selectedDistrict,
      selectedCrop,
      selectedSeason,
    );
  }

  // Dropdown items and selection of dropdown

  List<DropdownMenuItem> stateItems() {
    List<DropdownMenuItem> _list = [];
    for (var state in stateList) {
      _list.add(
        new DropdownMenuItem(
          value: state['id'],
          child: Text(state['name']),
        ),
      );
    }
    return _list;
  }

  List<DropdownMenuItem> districtItems() {
    List<DropdownMenuItem> _list = [];
    for (var district in districtList) {
      _list.add(
        new DropdownMenuItem(
          value: district['id'],
          child: Text(district['name']),
        ),
      );
    }
    return _list;
  }

  void selectedStateChange() {
    selectedDistrict = null;
    districtList = [];
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    refreshUI();
  }

  // Yield selection

  void cropSelected(String cropId, BuildContext context) {
    selectedCrop = cropId;
    Navigator.pop(context);
    refreshUI();
  }

  void seasonSelected(String season, BuildContext context) {
    selectedSeason = season;
    Navigator.pop(context);
    refreshUI();
  }

  // Create chart data

  void findColorsAndToChartData({
    @required StatisticsFilters filter,
    @required List statisticsData,
  }) {
    double _max = 0;
    double _min = double.infinity;
    statisticsData.asMap().forEach((key, dataItem) {
      if (dataItem.values.first > _max) {
        _max = double.parse(dataItem.values.first.toString());
      }
      if (dataItem.values.first < _min) {
        _min = double.parse(dataItem.values.first.toString());
      }
    });
    List<double> _ranges = [
      _min + ((_max - _min) / 3),
      _min + 2 * ((_max - _min) / 3),
    ];
    statisticsData.asMap().forEach((key, dataItem) {
      Color color;
      if (dataItem.values.first < _ranges[0]) {
        color = Colors.green;
      } else if (dataItem.values.first < _ranges[1]) {
        color = Colors.blue;
      } else {
        color = Colors.red;
      }

      if (filter == StatisticsFilters.Rainfall)
        rainfallChartData.add(
          new ChartData(
            x: dataItem.keys.first,
            y: dataItem.values.first,
            color: color,
          ),
        );
      else if (filter == StatisticsFilters.Temperature)
        temperatureChartData.add(
          new ChartData(
            x: dataItem.keys.first,
            y: dataItem.values.first,
            color: color,
          ),
        );
      else if (filter == StatisticsFilters.Humidity)
        humidityChartData.add(
          new ChartData(
            x: dataItem.keys.first,
            y: double.parse(dataItem.values.first.toString()),
            color: color,
          ),
        );
      else if (filter == StatisticsFilters.Yield)
        yieldChartData.add(
          new ChartData(
            x: dataItem.keys.first.toString(),
            y: dataItem.values.first,
            color: color,
          ),
        );
    });
  }

  // Change crop selected

  void changeCrop(BuildContext context) {
    cropList = [];
    seasonList = [];
    selectedSeason = null;
    selectedCrop = null;
    yieldStatisticsEntity = null;
    yieldFirstYear = null;
    fetchCropsList(context);
  }

  // Filters clicked

  void yieldClicked(BuildContext context) {
    if (!selectedFilters.contains(StatisticsFilters.Yield)) {
      cropList = [];
      seasonList = [];
      selectedSeason = null;
      selectedCrop = null;
      yieldStatisticsEntity = null;
      yieldFirstYear = null;
      fetchCropsList(context);
    } else {
      onFilterClicked(StatisticsFilters.Yield);
    }
  }

  void onFilterClicked(StatisticsFilters clickedFilter) {
    if (!selectedFilters.contains(clickedFilter) &&
        selectedFilters.length == 2) {
      selectedFilters.removeAt(0);
    }
    if (selectedFilters.contains(clickedFilter)) {
      selectedFilters.remove(clickedFilter);
      if (clickedFilter == selectedFilters1) {
        selectedFilters1 =
            selectedFilters.length == 1 ? selectedFilters2 : null;
        selectedFilters2 = null;
      } else if (clickedFilter == selectedFilters2) {
        selectedFilters2 = null;
      }
    } else {
      selectedFilters.add(clickedFilter);
      if (selectedFilters.length == 2) {
        if (selectedFilters[0] == StatisticsFilters.Temperature) {
          if (selectedFilters[1] == StatisticsFilters.Humidity) {
            if (humidityFirstYear < temperatureFirstYear) {
              selectedFilters1 = StatisticsFilters.Humidity;
              selectedFilters2 = StatisticsFilters.Temperature;
            } else {
              selectedFilters2 = StatisticsFilters.Humidity;
              selectedFilters1 = StatisticsFilters.Temperature;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Rainfall) {
            if (rainfallFirstYear < temperatureFirstYear) {
              selectedFilters1 = StatisticsFilters.Rainfall;
              selectedFilters2 = StatisticsFilters.Temperature;
            } else {
              selectedFilters2 = StatisticsFilters.Rainfall;
              selectedFilters1 = StatisticsFilters.Temperature;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Yield) {
            if (yieldFirstYear < temperatureFirstYear) {
              selectedFilters1 = StatisticsFilters.Yield;
              selectedFilters2 = StatisticsFilters.Temperature;
            } else {
              selectedFilters2 = StatisticsFilters.Yield;
              selectedFilters1 = StatisticsFilters.Temperature;
            }
          }
        } else if (selectedFilters[0] == StatisticsFilters.Humidity) {
          if (selectedFilters[1] == StatisticsFilters.Temperature) {
            if (temperatureFirstYear < humidityFirstYear) {
              selectedFilters1 = StatisticsFilters.Temperature;
              selectedFilters2 = StatisticsFilters.Humidity;
            } else {
              selectedFilters2 = StatisticsFilters.Temperature;
              selectedFilters1 = StatisticsFilters.Humidity;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Rainfall) {
            if (rainfallFirstYear < humidityFirstYear) {
              selectedFilters1 = StatisticsFilters.Rainfall;
              selectedFilters2 = StatisticsFilters.Humidity;
            } else {
              selectedFilters2 = StatisticsFilters.Rainfall;
              selectedFilters1 = StatisticsFilters.Humidity;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Yield) {
            if (yieldFirstYear < humidityFirstYear) {
              selectedFilters1 = StatisticsFilters.Yield;
              selectedFilters2 = StatisticsFilters.Humidity;
            } else {
              selectedFilters2 = StatisticsFilters.Yield;
              selectedFilters1 = StatisticsFilters.Humidity;
            }
          }
        } else if (selectedFilters[0] == StatisticsFilters.Rainfall) {
          if (selectedFilters[1] == StatisticsFilters.Temperature) {
            if (temperatureFirstYear < rainfallFirstYear) {
              selectedFilters1 = StatisticsFilters.Temperature;
              selectedFilters2 = StatisticsFilters.Rainfall;
            } else {
              selectedFilters2 = StatisticsFilters.Temperature;
              selectedFilters1 = StatisticsFilters.Rainfall;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Humidity) {
            if (humidityFirstYear < rainfallFirstYear) {
              selectedFilters1 = StatisticsFilters.Humidity;
              selectedFilters2 = StatisticsFilters.Rainfall;
            } else {
              selectedFilters2 = StatisticsFilters.Humidity;
              selectedFilters1 = StatisticsFilters.Rainfall;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Yield) {
            if (yieldFirstYear < rainfallFirstYear) {
              selectedFilters1 = StatisticsFilters.Yield;
              selectedFilters2 = StatisticsFilters.Rainfall;
            } else {
              selectedFilters2 = StatisticsFilters.Yield;
              selectedFilters1 = StatisticsFilters.Rainfall;
            }
          }
        } else if (selectedFilters[0] == StatisticsFilters.Yield) {
          if (selectedFilters[1] == StatisticsFilters.Temperature) {
            if (temperatureFirstYear < yieldFirstYear) {
              selectedFilters1 = StatisticsFilters.Temperature;
              selectedFilters2 = StatisticsFilters.Yield;
            } else {
              selectedFilters2 = StatisticsFilters.Temperature;
              selectedFilters1 = StatisticsFilters.Yield;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Rainfall) {
            if (rainfallFirstYear < yieldFirstYear) {
              selectedFilters1 = StatisticsFilters.Rainfall;
              selectedFilters2 = StatisticsFilters.Yield;
            } else {
              selectedFilters2 = StatisticsFilters.Rainfall;
              selectedFilters1 = StatisticsFilters.Yield;
            }
          } else if (selectedFilters[1] == StatisticsFilters.Humidity) {
            if (humidityFirstYear < yieldFirstYear) {
              selectedFilters1 = StatisticsFilters.Humidity;
              selectedFilters2 = StatisticsFilters.Yield;
            } else {
              selectedFilters2 = StatisticsFilters.Humidity;
              selectedFilters1 = StatisticsFilters.Yield;
            }
          }
        }
      } else if (selectedFilters.length == 1) {
        selectedFilters1 = clickedFilter;
        selectedFilters2 = null;
      }
    }

    refreshUI();
  }

  // utils

  List<ChartData> getPrimaryDatastore() {
    if (selectedFilters.length > 0) {
      if (selectedFilters1 == StatisticsFilters.Temperature)
        return temperatureChartData;
      else if (selectedFilters1 == StatisticsFilters.Humidity)
        return humidityChartData;
      else if (selectedFilters1 == StatisticsFilters.Rainfall)
        return rainfallChartData;
      else if (selectedFilters1 == StatisticsFilters.Yield)
        return yieldChartData;
      throw Exception('The filter is unknown');
    }

    throw Exception('The filter is unknown');
  }

  List<ChartData> getSecondaryDatastore() {
    if (selectedFilters.length == 2) {
      if (selectedFilters2 == StatisticsFilters.Temperature)
        return temperatureChartData;
      else if (selectedFilters2 == StatisticsFilters.Humidity)
        return humidityChartData;
      else if (selectedFilters2 == StatisticsFilters.Rainfall)
        return rainfallChartData;
      else if (selectedFilters2 == StatisticsFilters.Yield)
        return yieldChartData;
      throw Exception('The filter is unknown');
    }

    throw Exception('The filter is unknown');
  }

  String selectedStateName() {
    String name = stateList
        .singleWhere((element) => element['id'] == selectedState)['name'];
    return name;
  }

  String selectedDistrictName() {
    String name = districtList
        .singleWhere((element) => element['id'] == selectedDistrict)['name'];
    return name;
  }

  String getAxisLabelName(StatisticsFilters filters) {
    if (filters == StatisticsFilters.Temperature) {
      return 'Temperature (\u2103)';
    } else if (filters == StatisticsFilters.Humidity) {
      return 'Humidity (%)';
    } else if (filters == StatisticsFilters.Rainfall) {
      return 'Rainfall (mm)';
    } else if (filters == StatisticsFilters.Yield) {
      return 'Yield (quintals / acre)';
    }
    return '';
  }

  void navigateToViewGraph(StatisticsPageController controller) {
    navigationService.navigateTo(NavigationService.viewGraphPage,
        arguments: ViewGraphParams(statisticsPageController: controller));
  }

  bool onWillPopScopePage1() {
    if (selectedDistrict != null) {
      selectedDistrict = null;
    } else if (selectedState != null) {
      selectedState = null;
      selectedDistrict = null;
      districtList = [];
    }
    refreshUI();

    return false;
  }

  bool onWillPopScopePage2() {
    _stateMachine.onEvent(new StatisticsPageInputInitializedEvent());
    refreshUI();

    return false;
  }
}
