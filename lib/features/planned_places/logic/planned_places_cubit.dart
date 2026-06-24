import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/planned_place_model.dart';
import '../data/planned_places_repository.dart';
import 'planned_places_state.dart';

class PlannedPlacesCubit extends Cubit<PlannedPlacesState> {
  final PlannedPlacesRepository _repository;

  StreamSubscription<List<PlannedPlaceModel>>? _placesSubscription;

  PlannedPlacesCubit(this._repository)
    : super(const PlannedPlacesState.initial()) {
    _watchPlannedPlaces();
  }

  Future<bool> addPlace({
    required String title,
    required String? note,
    required double latitude,
    required double longitude,
  }) async {
    if (state.isSaving) {
      return false;
    }

    emit(state.copyWith(isSaving: true, actionFailureType: null));

    try {
      await _repository.addPlannedPlace(
        title: title,
        note: note,
        latitude: latitude,
        longitude: longitude,
      );

      emit(state.copyWith(isSaving: false));
      return true;
    } on PlannedPlacesException catch (error) {
      emit(state.copyWith(isSaving: false, actionFailureType: error.type));
      return false;
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          actionFailureType: PlannedPlacesFailureType.unknown,
        ),
      );
      return false;
    }
  }

  Future<void> removePlace(String placeId) async {
    try {
      await _repository.removePlannedPlace(placeId);
    } on PlannedPlacesException catch (error) {
      emit(state.copyWith(actionFailureType: error.type));
    } catch (_) {
      emit(state.copyWith(actionFailureType: PlannedPlacesFailureType.unknown));
    }
  }

  Future<void> togglePlaceCompletion(PlannedPlaceModel place) async {
    try {
      if (place.isCompleted) {
        await _repository.markAsOpen(place.id);
      } else {
        await _repository.markAsCompleted(place.id);
      }
    } on PlannedPlacesException catch (error) {
      emit(state.copyWith(actionFailureType: error.type));
    } catch (_) {
      emit(state.copyWith(actionFailureType: PlannedPlacesFailureType.unknown));
    }
  }

  void clearFailure() {
    if (state.failureType == null && state.actionFailureType == null) {
      return;
    }

    emit(state.copyWith(failureType: null, actionFailureType: null));
  }

  void _watchPlannedPlaces() {
    _placesSubscription = _repository.watchPlannedPlaces().listen(
      (places) {
        emit(
          state.copyWith(isLoading: false, places: places, failureType: null),
        );
      },
      onError: (error) {
        final failureType = error is PlannedPlacesException
            ? error.type
            : PlannedPlacesFailureType.unknown;

        emit(
          state.copyWith(
            isLoading: false,
            places: const [],
            failureType: failureType,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _placesSubscription?.cancel();
    return super.close();
  }
}
