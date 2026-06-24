import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TripDiaryLocalPhotoStorage {
  static const _photosDirectoryName = 'trip_diary_photos';

  const TripDiaryLocalPhotoStorage();

  Future<StoredTripDiaryPhoto> savePhoto({
    required File sourcePhoto,
    required String photoId,
  }) async {
    final directory = await _photosDirectory();
    final extension = _fileExtension(sourcePhoto.path);
    final fileName = '$photoId$extension';
    final targetFile = File('${directory.path}/$fileName');

    await sourcePhoto.copy(targetFile.path);

    return StoredTripDiaryPhoto(fileName: fileName, localPath: targetFile.path);
  }

  Future<File?> findPhoto(String? fileName) async {
    final normalizedFileName = fileName?.trim();

    if (normalizedFileName == null || normalizedFileName.isEmpty) {
      return null;
    }

    final directory = await _photosDirectory();
    final file = File('${directory.path}/$normalizedFileName');

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  Future<void> deletePhoto(String? fileName) async {
    final file = await findPhoto(fileName);

    if (file == null) return;

    await file.delete();
  }

  Future<Directory> _photosDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final photosDirectory = Directory(
      '${appDirectory.path}/$_photosDirectoryName',
    );

    if (!await photosDirectory.exists()) {
      await photosDirectory.create(recursive: true);
    }

    return photosDirectory;
  }

  String _fileExtension(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.png')) {
      return '.png';
    }

    if (lowerPath.endsWith('.webp')) {
      return '.webp';
    }

    if (lowerPath.endsWith('.heic')) {
      return '.heic';
    }

    return '.jpg';
  }
}

class StoredTripDiaryPhoto {
  final String fileName;
  final String localPath;

  const StoredTripDiaryPhoto({required this.fileName, required this.localPath});
}
