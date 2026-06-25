// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannedPlaceModel {

 String get id; String get title; String? get note; double get latitude; double get longitude; bool get isCompleted; DateTime? get createdAt; DateTime? get completedAt;
/// Create a copy of PlannedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedPlaceModelCopyWith<PlannedPlaceModel> get copyWith => _$PlannedPlaceModelCopyWithImpl<PlannedPlaceModel>(this as PlannedPlaceModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedPlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,note,latitude,longitude,isCompleted,createdAt,completedAt);

@override
String toString() {
  return 'PlannedPlaceModel(id: $id, title: $title, note: $note, latitude: $latitude, longitude: $longitude, isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $PlannedPlaceModelCopyWith<$Res>  {
  factory $PlannedPlaceModelCopyWith(PlannedPlaceModel value, $Res Function(PlannedPlaceModel) _then) = _$PlannedPlaceModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? note, double latitude, double longitude, bool isCompleted, DateTime? createdAt, DateTime? completedAt
});




}
/// @nodoc
class _$PlannedPlaceModelCopyWithImpl<$Res>
    implements $PlannedPlaceModelCopyWith<$Res> {
  _$PlannedPlaceModelCopyWithImpl(this._self, this._then);

  final PlannedPlaceModel _self;
  final $Res Function(PlannedPlaceModel) _then;

/// Create a copy of PlannedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? note = freezed,Object? latitude = null,Object? longitude = null,Object? isCompleted = null,Object? createdAt = freezed,Object? completedAt = freezed,}) {
  return _then(PlannedPlaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedPlaceModel].
extension PlannedPlaceModelPatterns on PlannedPlaceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedPlaceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedPlaceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedPlaceModel value)  $default,){
final _that = this;
switch (_that) {
case _PlannedPlaceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedPlaceModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedPlaceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? note,  double latitude,  double longitude,  bool isCompleted,  DateTime? createdAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedPlaceModel() when $default != null:
return $default(_that.id,_that.title,_that.note,_that.latitude,_that.longitude,_that.isCompleted,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? note,  double latitude,  double longitude,  bool isCompleted,  DateTime? createdAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _PlannedPlaceModel():
return $default(_that.id,_that.title,_that.note,_that.latitude,_that.longitude,_that.isCompleted,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? note,  double latitude,  double longitude,  bool isCompleted,  DateTime? createdAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlannedPlaceModel() when $default != null:
return $default(_that.id,_that.title,_that.note,_that.latitude,_that.longitude,_that.isCompleted,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedPlaceModel extends PlannedPlaceModel {
  const _PlannedPlaceModel({required this.id, required this.title, required this.note, required this.latitude, required this.longitude, required this.isCompleted, required this.createdAt, required this.completedAt}): super._();
  

@override final  String id;
@override final  String title;
@override final  String? note;
@override final  double latitude;
@override final  double longitude;
@override final  bool isCompleted;
@override final  DateTime? createdAt;
@override final  DateTime? completedAt;

/// Create a copy of PlannedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedPlaceModelCopyWith<_PlannedPlaceModel> get copyWith => __$PlannedPlaceModelCopyWithImpl<_PlannedPlaceModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedPlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,note,latitude,longitude,isCompleted,createdAt,completedAt);

@override
String toString() {
  return 'PlannedPlaceModel(id: $id, title: $title, note: $note, latitude: $latitude, longitude: $longitude, isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$PlannedPlaceModelCopyWith<$Res> implements $PlannedPlaceModelCopyWith<$Res> {
  factory _$PlannedPlaceModelCopyWith(_PlannedPlaceModel value, $Res Function(_PlannedPlaceModel) _then) = __$PlannedPlaceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? note, double latitude, double longitude, bool isCompleted, DateTime? createdAt, DateTime? completedAt
});




}
/// @nodoc
class __$PlannedPlaceModelCopyWithImpl<$Res>
    implements _$PlannedPlaceModelCopyWith<$Res> {
  __$PlannedPlaceModelCopyWithImpl(this._self, this._then);

  final _PlannedPlaceModel _self;
  final $Res Function(_PlannedPlaceModel) _then;

/// Create a copy of PlannedPlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? note = freezed,Object? latitude = null,Object? longitude = null,Object? isCompleted = null,Object? createdAt = freezed,Object? completedAt = freezed,}) {
  return _then(_PlannedPlaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
