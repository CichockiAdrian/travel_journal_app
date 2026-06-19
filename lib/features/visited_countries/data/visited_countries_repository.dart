import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../countries/data/country_model.dart';
import 'visited_country_id.dart';
import 'visited_country_model.dart';

enum VisitedCountriesFailureType { notAuthenticated, missingCountryId, unknown }

class VisitedCountriesException implements Exception {
  final VisitedCountriesFailureType type;

  const VisitedCountriesException(this.type);
}

class VisitedCountriesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const VisitedCountriesRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  Stream<List<VisitedCountryModel>> watchVisitedCountries() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return Stream.error(
        const VisitedCountriesException(
          VisitedCountriesFailureType.notAuthenticated,
        ),
      );
    }

    return _visitedCountriesCollection(
      user.uid,
    ).orderBy('visitedAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VisitedCountryModel.fromFirestore(id: doc.id, data: doc.data());
      }).toList();
    });
  }

  Future<void> markAsVisited(CountryModel country) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const VisitedCountriesException(
        VisitedCountriesFailureType.notAuthenticated,
      );
    }

    final countryId = VisitedCountryId.fromCountry(country);

    if (countryId == null) {
      throw const VisitedCountriesException(
        VisitedCountriesFailureType.missingCountryId,
      );
    }

    await _visitedCountriesCollection(user.uid).doc(countryId).set({
      'name': country.name,
      'flagUrl': country.flagUrl,
      'latitude': country.latitude,
      'longitude': country.longitude,
      'visitedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromVisited(CountryModel country) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw const VisitedCountriesException(
        VisitedCountriesFailureType.notAuthenticated,
      );
    }

    final countryId = VisitedCountryId.fromCountry(country);

    if (countryId == null) {
      throw const VisitedCountriesException(
        VisitedCountriesFailureType.missingCountryId,
      );
    }

    await _visitedCountriesCollection(user.uid).doc(countryId).delete();
  }

  CollectionReference<Map<String, dynamic>> _visitedCountriesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('visitedCountries');
  }
}
