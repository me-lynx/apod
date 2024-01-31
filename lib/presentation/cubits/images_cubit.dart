import 'package:apod/presentation/cubits/images_state.dart';
import 'package:apod/database_service.dart';
import 'package:apod/models/apod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final DatabaseService database;

  ImagesCubit({
    required this.database,
  }) : super(ImagesState.initial());

  void loadImages(DateTime startDate, DateTime endDate) async {
    try {
      List<Apod> images = await database.getApods(startDate, endDate);
      if (images.isEmpty) {
        emit(ImagesState.error(''));
      } else {
        emit(ImagesState.success(images));
      }
    } catch (e) {
      emit(ImagesState.error(''));
    }
  }

  Future<String> downloadImage(String url, String filename) async {
    final dio = Dio();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';

    await dio.download(url, path);

    return path;
  }

  Future<void> saveImage(
      Apod apod, DateTime startDate, DateTime endDate) async {
    try {
      if (await imageIsDownloaded(apod.url, startDate, endDate)) {
        emit(ImagesState.saved(apod.path!));
        return;
      }

      final path = await downloadImage(apod.url, '${apod.date}.jpg');
      final newApod = Apod(
        title: apod.title,
        explanation: apod.explanation,
        url: apod.url,
        date: apod.date,
        path: path,
      );

      await database.saveImage(newApod.title, newApod.explanation, newApod.url,
          newApod.date, newApod.path!);
    } catch (_) {
      emit(ImagesState.error(''));
    }
  }

  Future<bool> imageIsDownloaded(
      String imageUrl, DateTime startDate, DateTime endDate) async {
    List<Apod> apods = await database.getApods(startDate, endDate);
    for (Apod apod in apods) {
      if (apod.url == imageUrl) {
        return true;
      }
    }
    return false;
  }
}
