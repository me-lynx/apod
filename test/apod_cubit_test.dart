import 'package:apod/cubits/apod_cubit.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:apod/cubits/apod_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements InterceptorsWrapper {}

class MockApodRemoteDataSource extends Mock implements ApodRemoteDataSource {}

void main() {
  group('ApodCubit', () {
    late ApodCubit cubit;
    late MockApodRemoteDataSource dataSource;

    setUp(() {
      dataSource = MockApodRemoteDataSource();
      cubit = ApodCubit(
        dataSource,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, ApodState.initial());
    });
  });
}
