import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/photo_gallery_repository.dart';
import 'photo_gallery_state.dart';

class PhotoGalleryCubit extends Cubit<PhotoGalleryState> {
  PhotoGalleryCubit({required this.photoGalleryRepository})
    : super(const PhotoGalleryState.initial());

  final PhotoGalleryRepository photoGalleryRepository;

  Future<void> loadPhotos() async {
    emit(const PhotoGalleryState.loading());

    try {
      final photos = await photoGalleryRepository.loadPhotos();
      emit(PhotoGalleryState.loaded(photos: photos));
    } catch (_) {
      emit(const PhotoGalleryState.error());
    }
  }

  Future<bool> takePhoto() async {
    try {
      final photo = await photoGalleryRepository.takePhoto();

      if (photo == null) {
        return false;
      }

      final photos = await photoGalleryRepository.loadPhotos();
      emit(PhotoGalleryState.loaded(photos: photos));

      return true;
    } catch (_) {
      emit(const PhotoGalleryState.error());
      return false;
    }
  }

  Future<void> deletePhoto(String photoId) async {
    try {
      await photoGalleryRepository.deletePhoto(photoId);

      final photos = await photoGalleryRepository.loadPhotos();
      emit(PhotoGalleryState.loaded(photos: photos));
    } catch (_) {
      emit(const PhotoGalleryState.error());
    }
  }
}
