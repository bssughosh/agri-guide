import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/enums.dart';
import '../../../core/handle_api_errors.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import '../domain/entities/statistics_entity.dart';
import 'statistics_presenter.dart';
import 'statistics_state_machine.dart';
import 'statistics_view.dart';

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
  bool isStateFilterClicked = false;
  bool isDistrictFilterClicked = false;
  String selectedState;
  String selectedDistrict;
  bool districtListLoading = false;

  StatisticsEntity statisticsEntity;
  List<ChartData> rainfallChartData = [];
  List<ChartData> temperatureChartData = [];
  List<ChartData> humidityChartData = [];

  int temperatureFirstYear;
  int humidityFirstYear;
  int rainfallFirstYear;

  List<StatisticsFilters> selectedFilters = [];

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

  void selectedStateChange() {
    selectedDistrict = '';
    districtList = [];
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    refreshUI();
  }

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
    });
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

  // void handleFilter1Changed(StatisticsFilters newFilter) {
  //   selectedFilter2 = null;
  //   selectedFilter1 = newFilter;
  //   filter2 = [];
  //   for (StatisticsFilters filter in filter1) {
  //     if (filter != newFilter) {
  //       filter2.add(filter);
  //     }
  //   }
  //   selectedFilter2 = filter2[0];
  //   if (selectedFilter1 == StatisticsFilters.Temperature) {
  //     if (selectedFilter2 == StatisticsFilters.Humidity) {
  //       if (humidityFirstYear < temperatureFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Rainfall) {
  //       if (rainfallFirstYear < temperatureFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   } else if (selectedFilter1 == StatisticsFilters.Humidity) {
  //     if (selectedFilter2 == StatisticsFilters.Temperature) {
  //       if (temperatureFirstYear < humidityFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Rainfall) {
  //       if (rainfallFirstYear < humidityFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   } else if (selectedFilter1 == StatisticsFilters.Rainfall) {
  //     if (selectedFilter2 == StatisticsFilters.Temperature) {
  //       if (temperatureFirstYear < rainfallFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Humidity) {
  //       if (humidityFirstYear < rainfallFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   }
  //   refreshUI();
  // }

  // void handleFilter2Changed(StatisticsFilters newFilter) {
  //   selectedFilter2 = newFilter;
  //   if (selectedFilter1 == StatisticsFilters.Temperature) {
  //     if (selectedFilter2 == StatisticsFilters.Humidity) {
  //       if (humidityFirstYear < temperatureFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Rainfall) {
  //       if (rainfallFirstYear < temperatureFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   } else if (selectedFilter1 == StatisticsFilters.Humidity) {
  //     if (selectedFilter2 == StatisticsFilters.Temperature) {
  //       if (temperatureFirstYear < humidityFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Rainfall) {
  //       if (rainfallFirstYear < humidityFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   } else if (selectedFilter1 == StatisticsFilters.Rainfall) {
  //     if (selectedFilter2 == StatisticsFilters.Temperature) {
  //       if (temperatureFirstYear < rainfallFirstYear)
  //         areElementsToBeSwapped = true;
  //     } else if (selectedFilter2 == StatisticsFilters.Humidity) {
  //       if (humidityFirstYear < rainfallFirstYear)
  //         areElementsToBeSwapped = true;
  //     }
  //   }
  //   refreshUI();
  // }

  bool onWillPopScopePage1() {
    if (selectedDistrict != '') {
      selectedDistrict = '';
    } else if (selectedState != '') {
      selectedState = '';
      selectedDistrict = '';
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

  String getAxisLabelName(StatisticsFilters filters) {
    if (filters == StatisticsFilters.Temperature) {
      return 'Temperature (\u2103)';
    } else if (filters == StatisticsFilters.Humidity) {
      return 'Humidity (%)';
    } else if (filters == StatisticsFilters.Rainfall) {
      return 'Rainfall (mm)';
    }
    return '';
  }

  List<ChartData> getPrimaryDatastore() {
    if (selectedFilters.length > 0) {
      if (selectedFilters[0] == StatisticsFilters.Temperature)
        return temperatureChartData;
      else if (selectedFilters[0] == StatisticsFilters.Humidity)
        return humidityChartData;
      else if (selectedFilters[0] == StatisticsFilters.Rainfall)
        return rainfallChartData;
      throw Exception('The filter is unknown');
    }

    throw Exception('The filter is unknown');
  }

  List<ChartData> getSecondaryDatastore() {
    if (selectedFilters.length == 2) {
      // if (selectedFilters[0] == StatisticsFilters.Temperature) {
      //   if (selectedFilters[1] == StatisticsFilters.Humidity) {
      //     if (humidityFirstYear >= temperatureFirstYear) {
      //       return humidityChartData;
      //     }
      //     return temperatureChartData;
      //   } else if (selectedFilters[1] == StatisticsFilters.Rainfall) {
      //     if (rainfallFirstYear >= temperatureFirstYear) {
      //       return rainfallChartData;
      //     }
      //     return temperatureChartData;
      //   }
      // } else if (selectedFilters[0] == StatisticsFilters.Humidity) {
      //   if (selectedFilters[1] == StatisticsFilters.Temperature) {
      //     if (temperatureFirstYear >= humidityFirstYear) {
      //       return temperatureChartData;
      //     }
      //     return humidityChartData;
      //   } else if (selectedFilters[1] == StatisticsFilters.Rainfall) {
      //     if (rainfallFirstYear >= humidityFirstYear) {
      //       return rainfallChartData;
      //     }
      //     return humidityChartData;
      //   }
      // } else if (selectedFilters[0] == StatisticsFilters.Rainfall) {
      //   if (selectedFilters[1] == StatisticsFilters.Temperature) {
      //     if (temperatureFirstYear >= rainfallFirstYear) {
      //       return temperatureChartData;
      //     }
      //     return rainfallChartData;
      //   } else if (selectedFilters[1] == StatisticsFilters.Humidity) {
      //     if (humidityFirstYear >= rainfallFirstYear) {
      //       return humidityChartData;
      //     }
      //     return rainfallChartData;
      //   }
      // }
      if (selectedFilters[1] == StatisticsFilters.Temperature)
        return temperatureChartData;
      else if (selectedFilters[1] == StatisticsFilters.Humidity)
        return humidityChartData;
      else if (selectedFilters[1] == StatisticsFilters.Rainfall)
        return rainfallChartData;
      throw Exception('The filter is unknown');
    }

    throw Exception('The filter is unknown');
  }
}
