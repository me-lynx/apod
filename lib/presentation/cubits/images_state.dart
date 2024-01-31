import 'package:apod/models/apod.dart';
import 'package:equatable/equatable.dart';

class ImagesState extends Equatable {
  final List<Apod>? images;
  final bool isLoading;
  final String errorMessage;
  final String? imagePath;

  ImagesState({
    List<Apod>? images,
    this.imagePath = '',
    this.isLoading = false,
    this.errorMessage = '',
  }) : images = images ?? [];

  @override
  List<Object?> get props => [images, isLoading, errorMessage];

  factory ImagesState.initial() => ImagesState(
        images: const [],
        isLoading: false,
        errorMessage: '',
      );

  factory ImagesState.loading() => ImagesState(
        isLoading: true,
      );

  factory ImagesState.success(
    List<Apod> images,
  ) =>
      ImagesState(
        images: images,
        isLoading: false,
      );

  factory ImagesState.error(String errorMessage) => ImagesState(
        errorMessage: errorMessage,
        isLoading: false,
      );

  factory ImagesState.saved(String imagePath) => ImagesState(
        images: const [],
        isLoading: false,
        errorMessage: '',
        imagePath: imagePath,
      );

  ImagesState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return ImagesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
