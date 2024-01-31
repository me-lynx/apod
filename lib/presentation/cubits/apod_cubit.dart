import 'package:apod/models/apod.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:apod/presentation/cubits/apod_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApodCubit extends Cubit<ApodState> {
  final ApodRemoteDataSource dataSource;

  ApodCubit(
    this.dataSource,
  ) : super(ApodState.initial());

  Future<void> getApods(DateTime start, DateTime end) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<Apod> apods;
      apods = await dataSource.getApods(start, end);
      if (apods.isEmpty) {
        emit(state.copyWith(
            errorMessage:
                'Não há imagens salvas. Por favor, conecte-se à Terra para baixar mais.',
            isLoading: false));
      } else {
        emit(state.copyWith(apods: apods, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
