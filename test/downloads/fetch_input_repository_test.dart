import 'package:agri_guide/app/downloads/data/repositories/fetch_input_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FetchInputRepositoryImpl fetchInputRepositoryImpl;

  setUp(() {
    fetchInputRepositoryImpl = new FetchInputRepositoryImpl();
  });

  group('Fetch Input Repository Tests', () {
    test('should fetch state list', () async {
      expect(
        await fetchInputRepositoryImpl.getStateList(isTest: true),
        [
          {'id': 'Test', 'name': 'Test'}
        ],
      );
    });

    test('should fetch district list', () async {
      expect(
        await fetchInputRepositoryImpl.getDistrictList('1000'),
        [
          {'id': 'Test', 'state_id': 'Test', 'name': 'Test'}
        ],
      );
    });

    test('should fetch state names', () async {
      expect(
        await fetchInputRepositoryImpl
            .fetchStateNames(List<String>.from(['1001'])),
        [
          'Test',
        ],
      );
    });

    test('should fetch district names', () async {
      expect(
        await fetchInputRepositoryImpl
            .fetchDistNames(List<String>.from(['1000'])),
        [
          'Test',
        ],
      );
    });

    test('should fetch seasons list', () async {
      expect(
        await fetchInputRepositoryImpl.getSeasons('Test', 'Test'),
        [
          'Test',
        ],
      );
    });

    test('should fetch crops list', () async {
      expect(
        await fetchInputRepositoryImpl.getCrops('Test', 'Test', 'Test'),
        [
          {'crop_id': 'Test', 'name': 'Test'},
        ],
      );
    });
  });
}
