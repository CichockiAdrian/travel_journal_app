import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/photo_gallery_photo.dart';

part 'photo_gallery_state.freezed.dart';

@freezed
abstract class PhotoGalleryState with _$PhotoGalleryState {
  const factory PhotoGalleryState.initial() = _Initial;

  const factory PhotoGalleryState.loading() = _Loading;

  const factory PhotoGalleryState.loaded({
    required List<PhotoGalleryPhoto> photos,
  }) = _Loaded;

  const factory PhotoGalleryState.error() = _Error;
}
