import 'package:apod/models/apod.dart';
import 'package:equatable/equatable.dart';

class ApodState extends Equatable {
  final List<Apod>? apods;
  final bool isLoading;
  final String errorMessage;
  final DateTime? startDate;
  final DateTime? endDate;
  ApodState({
    List<Apod>? apods,
    this.isLoading = false,
    this.errorMessage = '',
    this.startDate,
    this.endDate,
  }) : apods = apods ?? [];

  @override
  List<Object?> get props =>
      [apods, isLoading, errorMessage, startDate, endDate];

  factory ApodState.initial() => ApodState(
        apods: const [],
        isLoading: false,
        errorMessage: '',
        startDate: null,
        endDate: null,
      );

  factory ApodState.loading() => ApodState(
        isLoading: true,
      );

  factory ApodState.success(
    List<Apod> apods,
  ) =>
      ApodState(
        apods: apods,
        isLoading: false,
      );

  factory ApodState.error(
          String errorMessage, DateTime? startDate, DateTime? endDate) =>
      ApodState(
        errorMessage: errorMessage,
        isLoading: false,
        startDate: startDate,
        endDate: endDate,
      );

  ApodState copyWith({
    List<Apod>? apods,
    bool? isLoading,
    String? errorMessage,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ApodState(
      apods: apods ?? this.apods,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
