import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_diary_entry.freezed.dart';

@freezed
abstract class TripDiaryEntry with _$TripDiaryEntry {
  const factory TripDiaryEntry({
    required String id,
    required String? title,
    required String? description,
    required String? countryCode,
    required String? countryName,
    required String? countryFlagUrl,
    required String? coverPhotoFileName,
    @Default(0) int photosCount,
    required DateTime? travelDate,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _TripDiaryEntry;
}
