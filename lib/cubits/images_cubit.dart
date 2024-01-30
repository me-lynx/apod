import 'package:apod/cubits/images_state.dart';
import 'package:apod/data/sqflite_apod_datasource.dart';
import 'package:apod/models/apod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final Database database;
  final SqfliteAPODDataSource dataSource;

  ImagesCubit({
    required this.dataSource,
    required this.database,
  }) : super(ImagesInitial());

  Future<void> loadImages() async {
    emit(ImagesLoading());
    try {
      await database.transaction((txn) async {
        List<Map> maps = await txn.query('APOD');
        List<String> imagePaths =
            maps.map((map) => map['path'] as String).toList();
        emit(ImagesLoaded(imagePaths));
      });
    } catch (_) {
      emit(ImagesError());
    }
  }

  Future<String> downloadImage(String url, String filename) async {
    final dio = Dio();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';

    await dio.download(url, path);

    return path;
  }

  Future<void> saveImage(Apod apod) async {
    try {
      final path = await downloadImage(apod.url, '${apod.date}.jpg');
      final newApod = Apod(
        title: apod.title,
        explanation: apod.explanation,
        url: apod.url,
        date: apod.date,
        path: path,
      );
      await dataSource.saveApod(newApod);
      emit(ImageSaved());
    } catch (_) {
      emit(ImageSaveError());
    }
  }
}
