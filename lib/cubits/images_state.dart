abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<String> imagePaths;

  ImagesLoaded(this.imagePaths);
}

class ImagesError extends ImagesState {}

class ImageSaving extends ImagesState {}

class ImageSaved extends ImagesState {}

class ImageSaveError extends ImagesState {}
