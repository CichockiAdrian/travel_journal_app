import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_gallery_photo.freezed.dart';
part 'photo_gallery_photo.g.dart';

@freezed
abstract class PhotoGalleryPhoto with _$PhotoGalleryPhoto {
  const factory PhotoGalleryPhoto({
    required String id,
    required String filePath,
    required DateTime createdAt,
    String? tripDiaryEntryId,
  }) = _PhotoGalleryPhoto;

  factory PhotoGalleryPhoto.fromJson(Map<String, dynamic> json) =>
      _$PhotoGalleryPhotoFromJson(json);
}
