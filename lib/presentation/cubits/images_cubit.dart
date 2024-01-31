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
  }) : super(ImagesInitial());

  void loadImages(DateTime startDate, DateTime endDate) async {
    try {
      List<Apod> images = await database.getApods(startDate, endDate);
      emit(ImagesLoaded(images));
    } catch (e) {
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
      await database.saveImage(newApod.title, newApod.explanation, newApod.url,
          newApod.date, newApod.path!);
      emit(ImageSaved());
    } catch (_) {
      emit(ImageSaveError());
    }
  }
}
