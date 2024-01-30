import 'package:apod/cubits/apod_cubit.dart';
import 'package:apod/data/apod_local_datasource.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:apod/cubits/apod_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements InterceptorsWrapper {}

class MockApodRemoteDataSource extends Mock implements ApodRemoteDataSource {}

class MockApodLocalDataSource extends Mock implements ApodLocalDataSource {}

void main() {
  group('ApodCubit', () {
    late ApodCubit cubit;
    late MockApodRemoteDataSource dataSource;
    late MockApodLocalDataSource localDataSource;

    setUp(() {
      dataSource = MockApodRemoteDataSource();
      localDataSource = MockApodLocalDataSource();
      cubit = ApodCubit(dataSource, localDataSource);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, ApodState.initial());
    });
  });
}