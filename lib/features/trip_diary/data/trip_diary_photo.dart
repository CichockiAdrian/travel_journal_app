import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_diary_photo.freezed.dart';

@freezed
abstract class TripDiaryPhoto with _$TripDiaryPhoto {
  const factory TripDiaryPhoto({
    required String id,
    required String? entryId,
    required String? countryCode,
    required String? localFileName,
    required DateTime? createdAt,
  }) = _TripDiaryPhoto;
}
