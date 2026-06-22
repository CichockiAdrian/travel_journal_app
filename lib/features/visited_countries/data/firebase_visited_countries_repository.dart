import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../countries/data/country_model.dart';
import 'visited_countries_repository.dart';
import 'visited_country_id.dart';
import 'visited_country_model.dart';

class FirebaseVisitedCountriesRepository implements VisitedCountriesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const FirebaseVisitedCountriesRepository(this._firestore, this._firebaseAuth);

  @override
  Stream<List<VisitedCountryModel>> watchVisitedCountries() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return Stream.error(
        const VisitedCountriesException(
          VisitedCountriesFailureType.notAuthenticated,
        ),
      );
    }

    return _visitedCountriesCollection(user.uid)
        .orderBy(VisitedCountryModel.visitedAtField, descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return VisitedCountryModel.fromFirestore(
              id: doc.id,
              data: doc.data(),
            );
          }).toList();
        });
  }

  @override
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

    final visitedCountry = VisitedCountryModel.fromCountry(
      id: countryId,
      country: country,
    );

    await _visitedCountriesCollection(
      user.uid,
    ).doc(countryId).set(visitedCountry.toFirestore(), SetOptions(merge: true));
  }

  @override
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
