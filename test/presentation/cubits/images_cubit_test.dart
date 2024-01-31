import 'package:apod/presentation/cubits/images_cubit.dart';
import 'package:apod/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements DatabaseService {}

void main() {
  group('ImagesCubit', () {
    late ImagesCubit imagesCubit;
    late MockDatabase database;
    late DateTime startDate;
    late DateTime endDate;
    setUp(() {
      database = MockDatabase();
      startDate = DateTime(2022, 1, 1);
      endDate = DateTime(2022, 12, 31);
      imagesCubit = ImagesCubit(database: database);
    });

    test('loadImages is called with correct dates', () async {
      when(imagesCubit.loadImages(startDate, endDate))
          .thenAnswer((_) async => {});

      imagesCubit.loadImages(startDate, endDate);

      verify(imagesCubit.loadImages(startDate, endDate)).called(1);
    });
  });
}
