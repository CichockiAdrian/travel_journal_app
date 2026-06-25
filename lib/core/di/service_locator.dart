import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/account/achievements/logic/achievements_calculator.dart';
import '../../features/account/activity_statistics/logic/profile_activity_stats_calculator.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/countries/data/countries_api_service.dart';
import '../../features/countries/data/countries_remote_data_source.dart';
import '../../features/countries/data/countries_repository.dart';
import '../../features/map/data/device_location_service.dart';
import '../../features/photo_gallery/data/photo_gallery_repository.dart';
import '../../features/planned_places/data/firebase_planned_places_repository.dart';
import '../../features/planned_places/data/planned_place_distance_calculator.dart';
import '../../features/planned_places/data/planned_places_nearby_checker.dart';
import '../../features/planned_places/data/planned_places_repository.dart';
import '../../features/planned_places/notifications/planned_places_notification_service.dart';
import '../../features/trip_diary/data/firebase_trip_diary_repository.dart';
import '../../features/trip_diary/data/trip_diary_local_photo_storage.dart';
import '../../features/trip_diary/data/trip_diary_repository.dart';
import '../../features/visited_countries/data/firebase_visited_countries_repository.dart';
import '../../features/visited_countries/data/visited_countries_repository.dart';
import '../../features/planned_places/background/planned_places_background_target_storage.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(firebaseAuth: getIt()),
  );

  getIt.registerLazySingleton(() => CountriesApiService());

  getIt.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSource(countriesApiService: getIt()),
  );

  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepository(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<VisitedCountriesRepository>(
    () => FirebaseVisitedCountriesRepository(getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => DeviceLocationService());

  getIt.registerLazySingleton<TripDiaryLocalPhotoStorage>(
    () => const TripDiaryLocalPhotoStorage(),
  );

  getIt.registerLazySingleton<TripDiaryRepository>(
    () => FirebaseTripDiaryRepository(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => const ProfileActivityStatsCalculator());

  getIt.registerLazySingleton<AchievementsCalculator>(
    () => const AchievementsCalculator(),
  );

  getIt.registerLazySingleton<PlannedPlacesRepository>(
    () => FirebasePlannedPlacesRepository(getIt(), getIt()),
  );

  getIt.registerLazySingleton<PlannedPlaceDistanceCalculator>(
    () => const PlannedPlaceDistanceCalculator(),
  );

  getIt.registerLazySingleton(() => PlannedPlacesBackgroundTargetStorage());

  getIt.registerLazySingleton<PlannedPlacesNotificationService>(
    () => PlannedPlacesNotificationService(),
  );

  getIt.registerLazySingleton(
    () => PlannedPlacesNearbyChecker(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => PhotoGalleryRepository(getIt(), getIt()));
}
