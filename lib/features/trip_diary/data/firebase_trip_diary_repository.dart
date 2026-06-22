import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../countries/data/country_model.dart';
import '../../visited_countries/data/visited_country_id.dart';
import 'trip_diary_entry.dart';
import 'trip_diary_repository.dart';

class FirebaseTripDiaryRepository implements TripDiaryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const FirebaseTripDiaryRepository(this._firestore, this._firebaseAuth);

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
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const TripDiaryException(TripDiaryFailureType.notAuthenticated);
    }

    final countryCode = VisitedCountryId.fromCountry(country);

    if (countryCode == null || countryCode.isEmpty) {
      throw const TripDiaryException(TripDiaryFailureType.missingCountryCode);
    }

    final entry = TripDiaryEntry(
      id: '',
      title: title.trim(),
      description: description.trim(),
      countryCode: countryCode,
      countryName: country.name,
      countryFlagUrl: country.flagUrl,
      travelDate: travelDate,
      createdAt: null,
      updatedAt: null,
    );

    await _entriesCollection(user.uid).add(entry.toCreateFirestore());
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const TripDiaryException(TripDiaryFailureType.notAuthenticated);
    }

    await _entriesCollection(user.uid).doc(entryId).delete();
  }

  CollectionReference<Map<String, dynamic>> _entriesCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tripDiaryEntries');
  }
}
