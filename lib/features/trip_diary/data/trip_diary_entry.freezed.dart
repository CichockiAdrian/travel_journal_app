// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_diary_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TripDiaryEntry {

 String get id; String? get title; String? get description; String? get countryCode; String? get countryName; String? get countryFlagUrl; String? get coverPhotoFileName; int get photosCount; DateTime? get travelDate; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of TripDiaryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDiaryEntryCopyWith<TripDiaryEntry> get copyWith => _$TripDiaryEntryCopyWithImpl<TripDiaryEntry>(this as TripDiaryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDiaryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryFlagUrl, countryFlagUrl) || other.countryFlagUrl == countryFlagUrl)&&(identical(other.coverPhotoFileName, coverPhotoFileName) || other.coverPhotoFileName == coverPhotoFileName)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,countryCode,countryName,countryFlagUrl,coverPhotoFileName,photosCount,travelDate,createdAt,updatedAt);

@override
String toString() {
  return 'TripDiaryEntry(id: $id, title: $title, description: $description, countryCode: $countryCode, countryName: $countryName, countryFlagUrl: $countryFlagUrl, coverPhotoFileName: $coverPhotoFileName, photosCount: $photosCount, travelDate: $travelDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TripDiaryEntryCopyWith<$Res>  {
  factory $TripDiaryEntryCopyWith(TripDiaryEntry value, $Res Function(TripDiaryEntry) _then) = _$TripDiaryEntryCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String? description, String? countryCode, String? countryName, String? countryFlagUrl, String? coverPhotoFileName, int photosCount, DateTime? travelDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$TripDiaryEntryCopyWithImpl<$Res>
    implements $TripDiaryEntryCopyWith<$Res> {
  _$TripDiaryEntryCopyWithImpl(this._self, this._then);

  final TripDiaryEntry _self;
  final $Res Function(TripDiaryEntry) _then;

/// Create a copy of TripDiaryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? countryCode = freezed,Object? countryName = freezed,Object? countryFlagUrl = freezed,Object? coverPhotoFileName = freezed,Object? photosCount = null,Object? travelDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(TripDiaryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryFlagUrl: freezed == countryFlagUrl ? _self.countryFlagUrl : countryFlagUrl // ignore: cast_nullable_to_non_nullable
as String?,coverPhotoFileName: freezed == coverPhotoFileName ? _self.coverPhotoFileName : coverPhotoFileName // ignore: cast_nullable_to_non_nullable
as String?,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripDiaryEntry].
extension TripDiaryEntryPatterns on TripDiaryEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDiaryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDiaryEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDiaryEntry value)  $default,){
final _that = this;
switch (_that) {
case _TripDiaryEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDiaryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TripDiaryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String? description,  String? countryCode,  String? countryName,  String? countryFlagUrl,  String? coverPhotoFileName,  int photosCount,  DateTime? travelDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDiaryEntry() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.countryCode,_that.countryName,_that.countryFlagUrl,_that.coverPhotoFileName,_that.photosCount,_that.travelDate,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String? description,  String? countryCode,  String? countryName,  String? countryFlagUrl,  String? coverPhotoFileName,  int photosCount,  DateTime? travelDate,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TripDiaryEntry():
return $default(_that.id,_that.title,_that.description,_that.countryCode,_that.countryName,_that.countryFlagUrl,_that.coverPhotoFileName,_that.photosCount,_that.travelDate,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String? description,  String? countryCode,  String? countryName,  String? countryFlagUrl,  String? coverPhotoFileName,  int photosCount,  DateTime? travelDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TripDiaryEntry() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.countryCode,_that.countryName,_that.countryFlagUrl,_that.coverPhotoFileName,_that.photosCount,_that.travelDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TripDiaryEntry extends TripDiaryEntry {
  const _TripDiaryEntry({required this.id, required this.title, required this.description, required this.countryCode, required this.countryName, required this.countryFlagUrl, required this.coverPhotoFileName, this.photosCount = 0, required this.travelDate, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String? title;
@override final  String? description;
@override final  String? countryCode;
@override final  String? countryName;
@override final  String? countryFlagUrl;
@override final  String? coverPhotoFileName;
@override@JsonKey() final  int photosCount;
@override final  DateTime? travelDate;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of TripDiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDiaryEntryCopyWith<_TripDiaryEntry> get copyWith => __$TripDiaryEntryCopyWithImpl<_TripDiaryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDiaryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryFlagUrl, countryFlagUrl) || other.countryFlagUrl == countryFlagUrl)&&(identical(other.coverPhotoFileName, coverPhotoFileName) || other.coverPhotoFileName == coverPhotoFileName)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,countryCode,countryName,countryFlagUrl,coverPhotoFileName,photosCount,travelDate,createdAt,updatedAt);

@override
String toString() {
  return 'TripDiaryEntry(id: $id, title: $title, description: $description, countryCode: $countryCode, countryName: $countryName, countryFlagUrl: $countryFlagUrl, coverPhotoFileName: $coverPhotoFileName, photosCount: $photosCount, travelDate: $travelDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TripDiaryEntryCopyWith<$Res> implements $TripDiaryEntryCopyWith<$Res> {
  factory _$TripDiaryEntryCopyWith(_TripDiaryEntry value, $Res Function(_TripDiaryEntry) _then) = __$TripDiaryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String? description, String? countryCode, String? countryName, String? countryFlagUrl, String? coverPhotoFileName, int photosCount, DateTime? travelDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$TripDiaryEntryCopyWithImpl<$Res>
    implements _$TripDiaryEntryCopyWith<$Res> {
  __$TripDiaryEntryCopyWithImpl(this._self, this._then);

  final _TripDiaryEntry _self;
  final $Res Function(_TripDiaryEntry) _then;

/// Create a copy of TripDiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? countryCode = freezed,Object? countryName = freezed,Object? countryFlagUrl = freezed,Object? coverPhotoFileName = freezed,Object? photosCount = null,Object? travelDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TripDiaryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryFlagUrl: freezed == countryFlagUrl ? _self.countryFlagUrl : countryFlagUrl // ignore: cast_nullable_to_non_nullable
as String?,coverPhotoFileName: freezed == coverPhotoFileName ? _self.coverPhotoFileName : coverPhotoFileName // ignore: cast_nullable_to_non_nullable
as String?,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
