// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visited_country_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisitedCountryModel {

 String get id; String? get name; String? get flagUrl; double? get latitude; double? get longitude; DateTime? get visitedAt;
/// Create a copy of VisitedCountryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitedCountryModelCopyWith<VisitedCountryModel> get copyWith => _$VisitedCountryModelCopyWithImpl<VisitedCountryModel>(this as VisitedCountryModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitedCountryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.flagUrl, flagUrl) || other.flagUrl == flagUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,flagUrl,latitude,longitude,visitedAt);

@override
String toString() {
  return 'VisitedCountryModel(id: $id, name: $name, flagUrl: $flagUrl, latitude: $latitude, longitude: $longitude, visitedAt: $visitedAt)';
}


}

/// @nodoc
abstract mixin class $VisitedCountryModelCopyWith<$Res>  {
  factory $VisitedCountryModelCopyWith(VisitedCountryModel value, $Res Function(VisitedCountryModel) _then) = _$VisitedCountryModelCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? flagUrl, double? latitude, double? longitude, DateTime? visitedAt
});




}
/// @nodoc
class _$VisitedCountryModelCopyWithImpl<$Res>
    implements $VisitedCountryModelCopyWith<$Res> {
  _$VisitedCountryModelCopyWithImpl(this._self, this._then);

  final VisitedCountryModel _self;
  final $Res Function(VisitedCountryModel) _then;

/// Create a copy of VisitedCountryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? flagUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? visitedAt = freezed,}) {
  return _then(VisitedCountryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,flagUrl: freezed == flagUrl ? _self.flagUrl : flagUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,visitedAt: freezed == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitedCountryModel].
extension VisitedCountryModelPatterns on VisitedCountryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitedCountryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitedCountryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitedCountryModel value)  $default,){
final _that = this;
switch (_that) {
case _VisitedCountryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitedCountryModel value)?  $default,){
final _that = this;
switch (_that) {
case _VisitedCountryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? flagUrl,  double? latitude,  double? longitude,  DateTime? visitedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitedCountryModel() when $default != null:
return $default(_that.id,_that.name,_that.flagUrl,_that.latitude,_that.longitude,_that.visitedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? flagUrl,  double? latitude,  double? longitude,  DateTime? visitedAt)  $default,) {final _that = this;
switch (_that) {
case _VisitedCountryModel():
return $default(_that.id,_that.name,_that.flagUrl,_that.latitude,_that.longitude,_that.visitedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? flagUrl,  double? latitude,  double? longitude,  DateTime? visitedAt)?  $default,) {final _that = this;
switch (_that) {
case _VisitedCountryModel() when $default != null:
return $default(_that.id,_that.name,_that.flagUrl,_that.latitude,_that.longitude,_that.visitedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VisitedCountryModel extends VisitedCountryModel {
  const _VisitedCountryModel({required this.id, required this.name, required this.flagUrl, required this.latitude, required this.longitude, required this.visitedAt}): super._();
  

@override final  String id;
@override final  String? name;
@override final  String? flagUrl;
@override final  double? latitude;
@override final  double? longitude;
@override final  DateTime? visitedAt;

/// Create a copy of VisitedCountryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitedCountryModelCopyWith<_VisitedCountryModel> get copyWith => __$VisitedCountryModelCopyWithImpl<_VisitedCountryModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitedCountryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.flagUrl, flagUrl) || other.flagUrl == flagUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,flagUrl,latitude,longitude,visitedAt);

@override
String toString() {
  return 'VisitedCountryModel(id: $id, name: $name, flagUrl: $flagUrl, latitude: $latitude, longitude: $longitude, visitedAt: $visitedAt)';
}


}

/// @nodoc
abstract mixin class _$VisitedCountryModelCopyWith<$Res> implements $VisitedCountryModelCopyWith<$Res> {
  factory _$VisitedCountryModelCopyWith(_VisitedCountryModel value, $Res Function(_VisitedCountryModel) _then) = __$VisitedCountryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? flagUrl, double? latitude, double? longitude, DateTime? visitedAt
});




}
/// @nodoc
class __$VisitedCountryModelCopyWithImpl<$Res>
    implements _$VisitedCountryModelCopyWith<$Res> {
  __$VisitedCountryModelCopyWithImpl(this._self, this._then);

  final _VisitedCountryModel _self;
  final $Res Function(_VisitedCountryModel) _then;

/// Create a copy of VisitedCountryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? flagUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? visitedAt = freezed,}) {
  return _then(_VisitedCountryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,flagUrl: freezed == flagUrl ? _self.flagUrl : flagUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,visitedAt: freezed == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
