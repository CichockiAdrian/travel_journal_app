// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_gallery_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotoGalleryPhoto _$PhotoGalleryPhotoFromJson(Map<String, dynamic> json) =>
    _PhotoGalleryPhoto(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tripDiaryEntryId: json['tripDiaryEntryId'] as String?,
    );

Map<String, dynamic> _$PhotoGalleryPhotoToJson(_PhotoGalleryPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filePath': instance.filePath,
      'createdAt': instance.createdAt.toIso8601String(),
      'tripDiaryEntryId': instance.tripDiaryEntryId,
    };
