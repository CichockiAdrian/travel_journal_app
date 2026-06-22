import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_journal_app/features/auth/data/auth_repository.dart';
import 'package:travel_journal_app/features/countries/data/countries_api_service.dart';
import 'package:travel_journal_app/features/countries/data/countries_remote_data_source.dart';

import '../../features/visited_countries/data/firebase_visited_countries_repository.dart';
import '../../features/visited_countries/data/visited_countries_repository.dart';
import '../../features/countries/data/countries_repository.dart';
import '../../features/map/data/device_location_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<CountriesApiService>(() => CountriesApiService());

  getIt.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSource(
      countriesApiService: getIt<CountriesApiService>(),
    ),
  );

  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepository(
      remoteDataSource: getIt<CountriesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<DeviceLocationService>(
    () => DeviceLocationService(),
  );

  getIt.registerLazySingleton<VisitedCountriesRepository>(
    () => FirebaseVisitedCountriesRepository(
      getIt<FirebaseFirestore>(),
      getIt<FirebaseAuth>(),
    ),
  );
}
