import 'package:apod/models/apod.dart';
import 'package:apod/data/apod_local_datasource.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:apod/cubits/apod_state.dart';
import 'package:apod/helpers/path_provider_save_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApodCubit extends Cubit<ApodState> {
  final ApodRemoteDataSource dataSource;
  final ApodLocalDataSource localDataSource;

  ApodCubit(this.dataSource, this.localDataSource) : super(ApodState.initial());

  Future<void> getApods(DateTime start, DateTime end) async {
    emit(state.copyWith(isLoading: true));
    try {
      var apodsHive = await localDataSource.getApods();
      List<Apod> apods;

      if (apodsHive.isEmpty) {
        apods = await dataSource.getApods(start, end);
      } else {
        apods = apodsHive.map(apodHiveToApod).toList();
      }
      for (var apod in apods) {
        await downloadAndSaveImage(apod.url, 'apod_${apod.date}.jpg');
      }
      emit(state.copyWith(apods: apods, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
