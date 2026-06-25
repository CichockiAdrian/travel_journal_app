import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../countries/data/country_model.dart';
import '../data/trip_diary_entry.dart';
import '../data/trip_diary_repository.dart';
import 'trip_diary_state.dart';
import '../data/trip_diary_photo.dart';

class TripDiaryCubit extends Cubit<TripDiaryState> {
  final TripDiaryRepository tripDiaryRepository;

  StreamSubscription<List<TripDiaryEntry>>? _entriesSubscription;

  TripDiaryCubit({required this.tripDiaryRepository})
    : super(const TripDiaryState());

  void watchEntries() {
    emit(state.copyWith(status: TripDiaryStatus.loading, errorMessage: null));

    _entriesSubscription?.cancel();

    _entriesSubscription = tripDiaryRepository.watchEntries().listen(
      (entries) {
        if (isClosed) return;

        emit(
          state.copyWith(
            status: TripDiaryStatus.success,
            entries: entries,
            errorMessage: null,
          ),
        );
      },
      onError: (error) {
        if (isClosed) return;

        emit(
          state.copyWith(
            status: TripDiaryStatus.failure,
            entries: const [],
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> addEntry({
    required String title,
    required String description,
    required CountryModel country,
    required DateTime travelDate,
    List<File> photos = const [],
  }) async {
    await tripDiaryRepository.addEntry(
      title: title,
      description: description,
      country: country,
      travelDate: travelDate,
      photos: photos,
    );
  }

  Stream<List<TripDiaryPhoto>> watchPhotosForEntry(String entryId) {
    return tripDiaryRepository.watchPhotosForEntry(entryId);
  }

  Future<void> deleteEntry(String entryId) async {
    await tripDiaryRepository.deleteEntry(entryId);
  }

  @override
  Future<void> close() async {
    await _entriesSubscription?.cancel();
    return super.close();
  }
}
