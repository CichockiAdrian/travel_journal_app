import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../trip_diary/data/trip_diary_local_photo_storage.dart';
import '../../trip_diary/data/trip_diary_repository.dart';
import 'photo_gallery_photo.dart';

class PhotoGalleryRepository {
  PhotoGalleryRepository({
    required TripDiaryRepository tripDiaryRepository,
    required TripDiaryLocalPhotoStorage tripDiaryLocalPhotoStorage,
    ImagePicker? imagePicker,
  }) : _tripDiaryRepository = tripDiaryRepository,
       _tripDiaryLocalPhotoStorage = tripDiaryLocalPhotoStorage,
       _imagePicker = imagePicker ?? ImagePicker();

  static const String _quickPhotosStorageKey = 'photo_gallery_photos';

  final TripDiaryRepository _tripDiaryRepository;
  final TripDiaryLocalPhotoStorage _tripDiaryLocalPhotoStorage;
  final ImagePicker _imagePicker;

  Future<List<PhotoGalleryPhoto>> loadPhotos() async {
    final quickPhotos = await _loadQuickPhotos();
    final tripDiaryPhotos = await _loadTripDiaryPhotos();

    final photosByPath = <String, PhotoGalleryPhoto>{};

    for (final photo in [...tripDiaryPhotos, ...quickPhotos]) {
      photosByPath[photo.filePath] = photo;
    }

    final photos = photosByPath.values.toList()
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));

    return photos;
  }

  Future<PhotoGalleryPhoto?> takePhoto() async {
    final pickedPhoto = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxWidth: 2400,
    );

    if (pickedPhoto == null) {
      return null;
    }

    final now = DateTime.now();
    final galleryDirectory = await _getGalleryDirectory();

    final extension = path.extension(pickedPhoto.path).isEmpty
        ? '.jpg'
        : path.extension(pickedPhoto.path);

    final fileName = 'photo_${now.millisecondsSinceEpoch}$extension';
    final savedFilePath = path.join(galleryDirectory.path, fileName);

    final savedFile = await File(pickedPhoto.path).copy(savedFilePath);

    final photo = PhotoGalleryPhoto(
      id: now.millisecondsSinceEpoch.toString(),
      filePath: savedFile.path,
      createdAt: now,
    );

    final currentQuickPhotos = await _loadQuickPhotos();
    await _saveQuickPhotos([photo, ...currentQuickPhotos]);

    return photo;
  }

  Future<void> deletePhoto(String photoId) async {
    final quickPhotos = await _loadQuickPhotos();

    PhotoGalleryPhoto? photoToDelete;

    for (final photo in quickPhotos) {
      if (photo.id == photoId) {
        photoToDelete = photo;
        break;
      }
    }

    if (photoToDelete == null) {
      return;
    }

    final file = File(photoToDelete.filePath);

    if (await file.exists()) {
      await file.delete();
    }

    final updatedPhotos = quickPhotos
        .where((photo) => photo.id != photoId)
        .toList();

    await _saveQuickPhotos(updatedPhotos);
  }

  Future<List<PhotoGalleryPhoto>> _loadQuickPhotos() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedPhotos =
        preferences.getStringList(_quickPhotosStorageKey) ?? [];

    final photos = <PhotoGalleryPhoto>[];

    for (final encodedPhoto in encodedPhotos) {
      try {
        final decodedPhoto = jsonDecode(encodedPhoto) as Map<String, dynamic>;
        final photo = PhotoGalleryPhoto.fromJson(decodedPhoto);

        if (await File(photo.filePath).exists()) {
          photos.add(photo);
        }
      } catch (_) {
        continue;
      }
    }

    if (photos.length != encodedPhotos.length) {
      await _saveQuickPhotos(photos);
    }

    return photos;
  }

  Future<List<PhotoGalleryPhoto>> _loadTripDiaryPhotos() async {
    final entries = await _tripDiaryRepository.watchEntries().first;
    final galleryPhotos = <PhotoGalleryPhoto>[];

    for (final entry in entries) {
      final photos = await _tripDiaryRepository
          .watchPhotosForEntry(entry.id)
          .first;

      for (final photo in photos) {
        final localFile = await _tripDiaryLocalPhotoStorage.findPhoto(
          photo.localFileName,
        );

        if (localFile == null || !await localFile.exists()) {
          continue;
        }

        final fileStat = await localFile.stat();

        galleryPhotos.add(
          PhotoGalleryPhoto(
            id: 'trip_${entry.id}_${photo.localFileName}',
            filePath: localFile.path,
            createdAt: fileStat.modified,
            tripDiaryEntryId: entry.id,
          ),
        );
      }
    }

    return galleryPhotos;
  }

  Future<void> _saveQuickPhotos(List<PhotoGalleryPhoto> photos) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedPhotos = photos
        .map((photo) => jsonEncode(photo.toJson()))
        .toList();

    await preferences.setStringList(_quickPhotosStorageKey, encodedPhotos);
  }

  Future<Directory> _getGalleryDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final galleryDirectory = Directory(
      path.join(documentsDirectory.path, 'photo_gallery'),
    );

    if (!await galleryDirectory.exists()) {
      await galleryDirectory.create(recursive: true);
    }

    return galleryDirectory;
  }
}
