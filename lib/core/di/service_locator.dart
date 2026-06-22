import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/countries/data/countries_api_service.dart';
import '../../features/countries/data/countries_remote_data_source.dart';
import '../../features/countries/data/countries_repository.dart';
import '../../features/map/data/device_location_service.dart';
import '../../features/trip_diary/data/firebase_trip_diary_repository.dart';
import '../../features/trip_diary/data/trip_diary_repository.dart';
import '../../features/visited_countries/data/firebase_visited_countries_repository.dart';
import '../../features/visited_countries/data/visited_countries_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(firebaseAuth: getIt()),
  );

  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton(() => CountriesApiService());

  getIt.registerLazySingleton(
    () => CountriesRemoteDataSource(countriesApiService: getIt()),
  );

  getIt.registerLazySingleton(
    () => CountriesRepository(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => DeviceLocationService());

  getIt.registerLazySingleton<VisitedCountriesRepository>(
    () => FirebaseVisitedCountriesRepository(getIt(), getIt()),
  );

  getIt.registerLazySingleton<TripDiaryRepository>(
    () => FirebaseTripDiaryRepository(getIt(), getIt()),
  );
}
