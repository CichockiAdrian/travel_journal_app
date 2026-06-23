import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../countries/data/country_model.dart';
import '../../visited_countries/data/visited_country_id.dart';
import 'trip_diary_entry.dart';
import 'trip_diary_limits.dart';
import 'trip_diary_photo.dart';
import 'trip_diary_repository.dart';

class FirebaseTripDiaryRepository implements TripDiaryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  const FirebaseTripDiaryRepository(
    this._firestore,
    this._firebaseAuth,
    this._firebaseStorage,
  );

  @override
  Stream<List<TripDiaryEntry>> watchEntries() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return Stream.error(
        const TripDiaryException(TripDiaryFailureType.notAuthenticated),
      );
    }

    return _entriesCollection(user.uid)
        .orderBy(TripDiaryEntry.travelDateField, descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TripDiaryEntry.fromFirestore(id: doc.id, data: doc.data());
          }).toList();
        });
  }

  @override
  Future<void> addEntry({
    required String title,
    required String description,
    required CountryModel country,
    required DateTime travelDate,
    List<File> photos = const [],
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const TripDiaryException(TripDiaryFailureType.notAuthenticated);
    }

    if (photos.length > TripDiaryLimits.maxPhotosPerEntry) {
      throw const TripDiaryException(TripDiaryFailureType.tooManyPhotos);
    }

    final countryId = VisitedCountryId.fromCountry(country)?.trim();

    if (countryId == null || countryId.isEmpty) {
      throw const TripDiaryException(TripDiaryFailureType.missingCountryCode);
    }

    final entryDoc = _entriesCollection(user.uid).doc();
    final uploadedPhotos = <_UploadedTripDiaryPhoto>[];

    try {
      for (final photo in photos) {
        final uploadedPhoto = await _uploadPhoto(
          userId: user.uid,
          entryId: entryDoc.id,
          countryCode: countryId,
          photo: photo,
        );

        uploadedPhotos.add(uploadedPhoto);
      }

      final entry = TripDiaryEntry(
        id: entryDoc.id,
        title: title.trim(),
        description: description.trim(),
        countryCode: countryId,
        countryName: country.name,
        countryFlagUrl: country.flagUrl,
        coverPhotoUrl: uploadedPhotos.isEmpty ? null : uploadedPhotos.first.url,
        photosCount: uploadedPhotos.length,
        travelDate: travelDate,
        createdAt: null,
        updatedAt: null,
      );

      final batch = _firestore.batch();

      batch.set(entryDoc, entry.toCreateFirestore());

      for (final uploadedPhoto in uploadedPhotos) {
        final photo = TripDiaryPhoto(
          id: uploadedPhoto.id,
          entryId: entryDoc.id,
          countryCode: countryId,
          url: uploadedPhoto.url,
          storagePath: uploadedPhoto.storagePath,
          createdAt: null,
        );

        batch.set(
          _photosCollection(user.uid).doc(uploadedPhoto.id),
          photo.toCreateFirestore(),
        );
      }

      await batch.commit();
    } catch (_) {
      await _deleteUploadedPhotos(uploadedPhotos);
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const TripDiaryException(TripDiaryFailureType.notAuthenticated);
    }

    await _entriesCollection(user.uid).doc(entryId).delete();
  }

  Future<_UploadedTripDiaryPhoto> _uploadPhoto({
    required String userId,
    required String entryId,
    required String countryCode,
    required File photo,
  }) async {
    final photoDoc = _photosCollection(userId).doc();
    final extension = _fileExtension(photo);
    final storagePath =
        'users/$userId/trip_diary/$entryId/${photoDoc.id}$extension';

    final storageReference = _firebaseStorage.ref().child(storagePath);

    await storageReference.putFile(
      photo,
      SettableMetadata(
        contentType: _contentType(photo),
        customMetadata: {'entryId': entryId, 'countryCode': countryCode},
      ),
    );

    final url = await storageReference.getDownloadURL();

    return _UploadedTripDiaryPhoto(
      id: photoDoc.id,
      url: url,
      storagePath: storagePath,
    );
  }

  Future<void> _deleteUploadedPhotos(
    List<_UploadedTripDiaryPhoto> uploadedPhotos,
  ) async {
    for (final uploadedPhoto in uploadedPhotos) {
      try {
        await _firebaseStorage.ref(uploadedPhoto.storagePath).delete();
      } catch (_) {
        // Best effort cleanup only.
      }
    }
  }

  String _fileExtension(File file) {
    final path = file.path.toLowerCase();

    if (path.endsWith('.png')) {
      return '.png';
    }

    if (path.endsWith('.webp')) {
      return '.webp';
    }

    if (path.endsWith('.heic')) {
      return '.heic';
    }

    return '.jpg';
  }

  String _contentType(File file) {
    final path = file.path.toLowerCase();

    if (path.endsWith('.png')) {
      return 'image/png';
    }

    if (path.endsWith('.webp')) {
      return 'image/webp';
    }

    if (path.endsWith('.heic')) {
      return 'image/heic';
    }

    return 'image/jpeg';
  }

  CollectionReference<Map<String, dynamic>> _entriesCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tripDiaryEntries');
  }

  CollectionReference<Map<String, dynamic>> _photosCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tripDiaryPhotos');
  }
}

class _UploadedTripDiaryPhoto {
  final String id;
  final String url;
  final String storagePath;

  const _UploadedTripDiaryPhoto({
    required this.id,
    required this.url,
    required this.storagePath,
  });
}
