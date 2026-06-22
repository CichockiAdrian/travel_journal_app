// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_diary_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TripDiaryPhoto {

 String get id; String? get entryId; String? get countryCode; String? get url; String? get storagePath; DateTime? get createdAt;
/// Create a copy of TripDiaryPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDiaryPhotoCopyWith<TripDiaryPhoto> get copyWith => _$TripDiaryPhotoCopyWithImpl<TripDiaryPhoto>(this as TripDiaryPhoto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDiaryPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.url, url) || other.url == url)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,entryId,countryCode,url,storagePath,createdAt);

@override
String toString() {
  return 'TripDiaryPhoto(id: $id, entryId: $entryId, countryCode: $countryCode, url: $url, storagePath: $storagePath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TripDiaryPhotoCopyWith<$Res>  {
  factory $TripDiaryPhotoCopyWith(TripDiaryPhoto value, $Res Function(TripDiaryPhoto) _then) = _$TripDiaryPhotoCopyWithImpl;
@useResult
$Res call({
 String id, String? entryId, String? countryCode, String? url, String? storagePath, DateTime? createdAt
});




}
/// @nodoc
class _$TripDiaryPhotoCopyWithImpl<$Res>
    implements $TripDiaryPhotoCopyWith<$Res> {
  _$TripDiaryPhotoCopyWithImpl(this._self, this._then);

  final TripDiaryPhoto _self;
  final $Res Function(TripDiaryPhoto) _then;

/// Create a copy of TripDiaryPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entryId = freezed,Object? countryCode = freezed,Object? url = freezed,Object? storagePath = freezed,Object? createdAt = freezed,}) {
  return _then(TripDiaryPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripDiaryPhoto].
extension TripDiaryPhotoPatterns on TripDiaryPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDiaryPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDiaryPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDiaryPhoto value)  $default,){
final _that = this;
switch (_that) {
case _TripDiaryPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDiaryPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _TripDiaryPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? entryId,  String? countryCode,  String? url,  String? storagePath,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDiaryPhoto() when $default != null:
return $default(_that.id,_that.entryId,_that.countryCode,_that.url,_that.storagePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? entryId,  String? countryCode,  String? url,  String? storagePath,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TripDiaryPhoto():
return $default(_that.id,_that.entryId,_that.countryCode,_that.url,_that.storagePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? entryId,  String? countryCode,  String? url,  String? storagePath,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TripDiaryPhoto() when $default != null:
return $default(_that.id,_that.entryId,_that.countryCode,_that.url,_that.storagePath,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TripDiaryPhoto extends TripDiaryPhoto {
  const _TripDiaryPhoto({required this.id, required this.entryId, required this.countryCode, required this.url, required this.storagePath, required this.createdAt}): super._();
  

@override final  String id;
@override final  String? entryId;
@override final  String? countryCode;
@override final  String? url;
@override final  String? storagePath;
@override final  DateTime? createdAt;

/// Create a copy of TripDiaryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDiaryPhotoCopyWith<_TripDiaryPhoto> get copyWith => __$TripDiaryPhotoCopyWithImpl<_TripDiaryPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDiaryPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.url, url) || other.url == url)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,entryId,countryCode,url,storagePath,createdAt);

@override
String toString() {
  return 'TripDiaryPhoto(id: $id, entryId: $entryId, countryCode: $countryCode, url: $url, storagePath: $storagePath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TripDiaryPhotoCopyWith<$Res> implements $TripDiaryPhotoCopyWith<$Res> {
  factory _$TripDiaryPhotoCopyWith(_TripDiaryPhoto value, $Res Function(_TripDiaryPhoto) _then) = __$TripDiaryPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? entryId, String? countryCode, String? url, String? storagePath, DateTime? createdAt
});




}
/// @nodoc
class __$TripDiaryPhotoCopyWithImpl<$Res>
    implements _$TripDiaryPhotoCopyWith<$Res> {
  __$TripDiaryPhotoCopyWithImpl(this._self, this._then);

  final _TripDiaryPhoto _self;
  final $Res Function(_TripDiaryPhoto) _then;

/// Create a copy of TripDiaryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entryId = freezed,Object? countryCode = freezed,Object? url = freezed,Object? storagePath = freezed,Object? createdAt = freezed,}) {
  return _then(_TripDiaryPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
