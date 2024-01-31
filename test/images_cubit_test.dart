import 'package:apod/presentation/cubits/images_cubit.dart';
import 'package:apod/presentation/cubits/images_state.dart';
import 'package:apod/database_service.dart';
import 'package:apod/models/apod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements DatabaseService {}

void main() {
  group('ImagesCubit', () {
    late ImagesCubit imagesCubit;
    late MockDatabase database;

    setUp(() {
      database = MockDatabase();
      imagesCubit = ImagesCubit(database: database);
    });

    test('Initial state is ImagesInitial', () {
      expect(imagesCubit.state, ImagesInitial());
    });

    test('loadImages emits ImagesLoaded with image paths', () async {
      final imagePaths = ['path1', 'path2'];
      when(database.getApods()).thenAnswer((_) async => imagePaths);

      imagesCubit.loadImages();

      await untilCalled(database.getApods());

      expect(imagesCubit.state, ImagesLoaded(imagePaths));
    });

    test('loadImages emits ImagesLoadError when an error occurs', () async {
      const error = 'Error loading images';
      when(database.getApods()).thenThrow(error);

      imagesCubit.loadImages();

      await untilCalled(database.getApods());

      expect(imagesCubit.state, ErrorDescription(error));
    });

    test('saveImage emits ImageSaved when image is saved successfully',
        () async {
      final apod = Apod(
        title: 'Test Apod',
        explanation: 'Test explanation',
        url: 'https://example.com/image.jpg',
        date: '2022-01-01',
      );
      const imagePath = '/path/to/image.jpg';

      when(database.saveImage('any', 'any', 'any', 'any', 'any'))
          .thenAnswer((_) async {});
      when(imagesCubit.downloadImage('any', 'any'))
          .thenAnswer((_) async => imagePath);

      imagesCubit.saveImage(apod);

      await untilCalled(database.saveImage('any', 'any', 'any', 'any', 'any'));
      await untilCalled(imagesCubit.downloadImage('any', 'any'));

      expect(imagesCubit.state, ImageSaved());
    });

    test('saveImage emits ImageSaveError when an error occurs', () async {
      final apod = Apod(
        title: 'Test Apod',
        explanation: 'Test explanation',
        url: 'https://example.com/image.jpg',
        date: '2022-01-01',
      );

      when(database.saveImage('any', 'any', 'any', 'any', 'any'))
          .thenThrow('Error saving image');
      when(imagesCubit.downloadImage('any', 'any'))
          .thenAnswer((_) async => '/path/to/image.jpg');

      imagesCubit.saveImage(apod);

      await untilCalled(database.saveImage('any', 'any', 'any', 'any', 'any'));
      await untilCalled(imagesCubit.downloadImage('any', 'any'));

      expect(imagesCubit.state, ImageSaveError());
    });
  });
}
