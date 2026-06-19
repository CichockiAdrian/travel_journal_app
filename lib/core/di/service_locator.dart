import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_journal_app/features/auth/data/auth_repository.dart';
import 'package:travel_journal_app/features/countries/data/countries_api_service.dart';
import 'package:travel_journal_app/features/countries/data/countries_remote_data_source.dart';
import 'package:travel_journal_app/features/countries/data/countries_repository.dart';
import '../../features/map/data/device_location_service.dart';
import '../../features/map/logic/map_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(firebaseAuth: getIt<FirebaseAuth>()),
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

  getIt.registerFactory<MapCubit>(() => MapCubit(getIt()));
}
