abstract class ApodEvent {}

class GetApodsEvent extends ApodEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  GetApodsEvent({
    this.startDate,
    this.endDate,
  });
}
