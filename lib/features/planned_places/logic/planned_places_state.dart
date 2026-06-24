import '../data/planned_place_model.dart';
import '../data/planned_places_repository.dart';

class PlannedPlacesState {
  static const Object _unset = Object();

  final bool isLoading;
  final bool isSaving;
  final List<PlannedPlaceModel> places;
  final PlannedPlacesFailureType? failureType;
  final PlannedPlacesFailureType? actionFailureType;

  const PlannedPlacesState({
    required this.isLoading,
    required this.isSaving,
    required this.places,
    required this.failureType,
    required this.actionFailureType,
  });

  const PlannedPlacesState.initial()
    : isLoading = true,
      isSaving = false,
      places = const [],
      failureType = null,
      actionFailureType = null;

  PlannedPlacesState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<PlannedPlaceModel>? places,
    Object? failureType = _unset,
    Object? actionFailureType = _unset,
  }) {
    return PlannedPlacesState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      places: places ?? this.places,
      failureType: failureType == _unset
          ? this.failureType
          : failureType as PlannedPlacesFailureType?,
      actionFailureType: actionFailureType == _unset
          ? this.actionFailureType
          : actionFailureType as PlannedPlacesFailureType?,
    );
  }
}
