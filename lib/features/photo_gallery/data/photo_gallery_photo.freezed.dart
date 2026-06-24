// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_gallery_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoGalleryPhoto {

 String get id; String get filePath; DateTime get createdAt; String? get tripDiaryEntryId;
/// Create a copy of PhotoGalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoGalleryPhotoCopyWith<PhotoGalleryPhoto> get copyWith => _$PhotoGalleryPhotoCopyWithImpl<PhotoGalleryPhoto>(this as PhotoGalleryPhoto, _$identity);

  /// Serializes this PhotoGalleryPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoGalleryPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.tripDiaryEntryId, tripDiaryEntryId) || other.tripDiaryEntryId == tripDiaryEntryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filePath,createdAt,tripDiaryEntryId);

@override
String toString() {
  return 'PhotoGalleryPhoto(id: $id, filePath: $filePath, createdAt: $createdAt, tripDiaryEntryId: $tripDiaryEntryId)';
}


}

/// @nodoc
abstract mixin class $PhotoGalleryPhotoCopyWith<$Res>  {
  factory $PhotoGalleryPhotoCopyWith(PhotoGalleryPhoto value, $Res Function(PhotoGalleryPhoto) _then) = _$PhotoGalleryPhotoCopyWithImpl;
@useResult
$Res call({
 String id, String filePath, DateTime createdAt, String? tripDiaryEntryId
});




}
/// @nodoc
class _$PhotoGalleryPhotoCopyWithImpl<$Res>
    implements $PhotoGalleryPhotoCopyWith<$Res> {
  _$PhotoGalleryPhotoCopyWithImpl(this._self, this._then);

  final PhotoGalleryPhoto _self;
  final $Res Function(PhotoGalleryPhoto) _then;

/// Create a copy of PhotoGalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filePath = null,Object? createdAt = null,Object? tripDiaryEntryId = freezed,}) {
  return _then(PhotoGalleryPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tripDiaryEntryId: freezed == tripDiaryEntryId ? _self.tripDiaryEntryId : tripDiaryEntryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoGalleryPhoto].
extension PhotoGalleryPhotoPatterns on PhotoGalleryPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoGalleryPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoGalleryPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoGalleryPhoto value)  $default,){
final _that = this;
switch (_that) {
case _PhotoGalleryPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoGalleryPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoGalleryPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String filePath,  DateTime createdAt,  String? tripDiaryEntryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoGalleryPhoto() when $default != null:
return $default(_that.id,_that.filePath,_that.createdAt,_that.tripDiaryEntryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String filePath,  DateTime createdAt,  String? tripDiaryEntryId)  $default,) {final _that = this;
switch (_that) {
case _PhotoGalleryPhoto():
return $default(_that.id,_that.filePath,_that.createdAt,_that.tripDiaryEntryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String filePath,  DateTime createdAt,  String? tripDiaryEntryId)?  $default,) {final _that = this;
switch (_that) {
case _PhotoGalleryPhoto() when $default != null:
return $default(_that.id,_that.filePath,_that.createdAt,_that.tripDiaryEntryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoGalleryPhoto implements PhotoGalleryPhoto {
  const _PhotoGalleryPhoto({required this.id, required this.filePath, required this.createdAt, this.tripDiaryEntryId});
  factory _PhotoGalleryPhoto.fromJson(Map<String, dynamic> json) => _$PhotoGalleryPhotoFromJson(json);

@override final  String id;
@override final  String filePath;
@override final  DateTime createdAt;
@override final  String? tripDiaryEntryId;

/// Create a copy of PhotoGalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoGalleryPhotoCopyWith<_PhotoGalleryPhoto> get copyWith => __$PhotoGalleryPhotoCopyWithImpl<_PhotoGalleryPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoGalleryPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoGalleryPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.tripDiaryEntryId, tripDiaryEntryId) || other.tripDiaryEntryId == tripDiaryEntryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filePath,createdAt,tripDiaryEntryId);

@override
String toString() {
  return 'PhotoGalleryPhoto(id: $id, filePath: $filePath, createdAt: $createdAt, tripDiaryEntryId: $tripDiaryEntryId)';
}


}

/// @nodoc
abstract mixin class _$PhotoGalleryPhotoCopyWith<$Res> implements $PhotoGalleryPhotoCopyWith<$Res> {
  factory _$PhotoGalleryPhotoCopyWith(_PhotoGalleryPhoto value, $Res Function(_PhotoGalleryPhoto) _then) = __$PhotoGalleryPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String filePath, DateTime createdAt, String? tripDiaryEntryId
});




}
/// @nodoc
class __$PhotoGalleryPhotoCopyWithImpl<$Res>
    implements _$PhotoGalleryPhotoCopyWith<$Res> {
  __$PhotoGalleryPhotoCopyWithImpl(this._self, this._then);

  final _PhotoGalleryPhoto _self;
  final $Res Function(_PhotoGalleryPhoto) _then;

/// Create a copy of PhotoGalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filePath = null,Object? createdAt = null,Object? tripDiaryEntryId = freezed,}) {
  return _then(_PhotoGalleryPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tripDiaryEntryId: freezed == tripDiaryEntryId ? _self.tripDiaryEntryId : tripDiaryEntryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
