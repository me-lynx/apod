import 'package:apod/models/apod.dart';

abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<Apod> images;

  ImagesLoaded(this.images);
}

class ImagesError extends ImagesState {}

class ImageSaving extends ImagesState {}

class ImageSaved extends ImagesState {}

class ImageSaveError extends ImagesState {}
