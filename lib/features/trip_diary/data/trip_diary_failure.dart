enum TripDiaryFailureType {
  notAuthenticated,
  missingCountryCode,
  tooManyPhotos,
  unknown,
}

class TripDiaryException implements Exception {
  final TripDiaryFailureType type;

  const TripDiaryException(this.type);
}
