import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'planned_place_model.dart';
import 'planned_places_repository.dart';

class FirebasePlannedPlacesRepository implements PlannedPlacesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const FirebasePlannedPlacesRepository(this._firestore, this._firebaseAuth);

  @override
  Stream<List<PlannedPlaceModel>> watchPlannedPlaces() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return Stream.error(
        const PlannedPlacesException(PlannedPlacesFailureType.notAuthenticated),
      );
    }

    return _plannedPlacesCollection(user.uid)
        .orderBy(PlannedPlaceModel.createdAtField, descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PlannedPlaceModel.fromFirestore(
              id: doc.id,
              data: doc.data(),
            );
          }).toList();
        });
  }

  @override
  Future<void> addPlannedPlace({
    required String title,
    required String? note,
    required double latitude,
    required double longitude,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const PlannedPlacesException(
        PlannedPlacesFailureType.notAuthenticated,
      );
    }

    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw const PlannedPlacesException(PlannedPlacesFailureType.invalidTitle);
    }

    if (!_areValidCoordinates(latitude: latitude, longitude: longitude)) {
      throw const PlannedPlacesException(
        PlannedPlacesFailureType.invalidCoordinates,
      );
    }

    final document = _plannedPlacesCollection(user.uid).doc();

    final plannedPlace = PlannedPlaceModel(
      id: document.id,
      title: trimmedTitle,
      note: note,
      latitude: latitude,
      longitude: longitude,
      isCompleted: false,
      createdAt: null,
      completedAt: null,
    );

    await document.set(plannedPlace.toCreateFirestore());
  }

  @override
  Future<void> removePlannedPlace(String placeId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const PlannedPlacesException(
        PlannedPlacesFailureType.notAuthenticated,
      );
    }

    await _plannedPlacesCollection(user.uid).doc(placeId).delete();
  }

  @override
  Future<void> markAsCompleted(String placeId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const PlannedPlacesException(
        PlannedPlacesFailureType.notAuthenticated,
      );
    }

    await _plannedPlacesCollection(user.uid).doc(placeId).update({
      PlannedPlaceModel.isCompletedField: true,
      PlannedPlaceModel.completedAtField: FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> markAsOpen(String placeId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const PlannedPlacesException(
        PlannedPlacesFailureType.notAuthenticated,
      );
    }

    await _plannedPlacesCollection(user.uid).doc(placeId).update({
      PlannedPlaceModel.isCompletedField: false,
      PlannedPlaceModel.completedAtField: FieldValue.delete(),
    });
  }

  CollectionReference<Map<String, dynamic>> _plannedPlacesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('plannedPlaces');
  }

  bool _areValidCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }
}
