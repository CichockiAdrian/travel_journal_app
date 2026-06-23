import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../countries/data/country_model.dart';
import '../../visited_countries/data/visited_country_id.dart';
import 'trip_diary_entry.dart';
import 'trip_diary_limits.dart';
import 'trip_diary_local_photo_storage.dart';
import 'trip_diary_photo.dart';
import 'trip_diary_repository.dart';

class FirebaseTripDiaryRepository implements TripDiaryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final TripDiaryLocalPhotoStorage _localPhotoStorage;

  const FirebaseTripDiaryRepository(
    this._firestore,
    this._firebaseAuth,
    this._localPhotoStorage,
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
  Stream<List<TripDiaryPhoto>> watchPhotosForEntry(String entryId) {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return Stream.error(
        const TripDiaryException(TripDiaryFailureType.notAuthenticated),
      );
    }

    return _photosCollection(user.uid)
        .where(TripDiaryPhoto.entryIdField, isEqualTo: entryId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TripDiaryPhoto.fromFirestore(id: doc.id, data: doc.data());
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

    final countryCode = VisitedCountryId.fromCountry(country)?.trim();

    if (countryCode == null || countryCode.isEmpty) {
      throw const TripDiaryException(TripDiaryFailureType.missingCountryCode);
    }

    final entryDoc = _entriesCollection(user.uid).doc();
    final storedPhotos = <_StoredPhotoWithId>[];

    try {
      for (final photo in photos) {
        final photoDoc = _photosCollection(user.uid).doc();
        final storedPhoto = await _localPhotoStorage.savePhoto(
          sourcePhoto: photo,
          photoId: photoDoc.id,
        );

        storedPhotos.add(
          _StoredPhotoWithId(id: photoDoc.id, fileName: storedPhoto.fileName),
        );
      }

      final entry = TripDiaryEntry(
        id: entryDoc.id,
        title: title.trim(),
        description: description.trim(),
        countryCode: countryCode,
        countryName: country.name,
        countryFlagUrl: country.flagUrl,
        coverPhotoFileName: storedPhotos.isEmpty
            ? null
            : storedPhotos.first.fileName,
        photosCount: storedPhotos.length,
        travelDate: travelDate,
        createdAt: null,
        updatedAt: null,
      );

      final batch = _firestore.batch();

      batch.set(entryDoc, entry.toCreateFirestore());

      for (final storedPhoto in storedPhotos) {
        final photo = TripDiaryPhoto(
          id: storedPhoto.id,
          entryId: entryDoc.id,
          countryCode: countryCode,
          localFileName: storedPhoto.fileName,
          createdAt: null,
        );

        batch.set(
          _photosCollection(user.uid).doc(storedPhoto.id),
          photo.toCreateFirestore(),
        );
      }

      await batch.commit();
    } catch (_) {
      for (final storedPhoto in storedPhotos) {
        await _localPhotoStorage.deletePhoto(storedPhoto.fileName);
      }

      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const TripDiaryException(TripDiaryFailureType.notAuthenticated);
    }

    final photosSnapshot = await _photosCollection(
      user.uid,
    ).where(TripDiaryPhoto.entryIdField, isEqualTo: entryId).get();

    final batch = _firestore.batch();

    batch.delete(_entriesCollection(user.uid).doc(entryId));

    for (final photoDoc in photosSnapshot.docs) {
      batch.delete(photoDoc.reference);
    }

    await batch.commit();

    for (final photoDoc in photosSnapshot.docs) {
      final photo = TripDiaryPhoto.fromFirestore(
        id: photoDoc.id,
        data: photoDoc.data(),
      );

      await _localPhotoStorage.deletePhoto(photo.localFileName);
    }
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

class _StoredPhotoWithId {
  final String id;
  final String fileName;

  const _StoredPhotoWithId({required this.id, required this.fileName});
}
