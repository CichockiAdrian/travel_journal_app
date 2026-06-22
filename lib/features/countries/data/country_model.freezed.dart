// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountryModel {

 String get name; String? get code; Map<String, String> get translatedNames; String? get capital; String? get flagUrl; String get region; String? get subregion; int? get population; double? get latitude; double? get longitude;
/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryModelCopyWith<CountryModel> get copyWith => _$CountryModelCopyWithImpl<CountryModel>(this as CountryModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryModel&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.translatedNames, translatedNames)&&(identical(other.capital, capital) || other.capital == capital)&&(identical(other.flagUrl, flagUrl) || other.flagUrl == flagUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.subregion, subregion) || other.subregion == subregion)&&(identical(other.population, population) || other.population == population)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,name,code,const DeepCollectionEquality().hash(translatedNames),capital,flagUrl,region,subregion,population,latitude,longitude);

@override
String toString() {
  return 'CountryModel(name: $name, code: $code, translatedNames: $translatedNames, capital: $capital, flagUrl: $flagUrl, region: $region, subregion: $subregion, population: $population, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $CountryModelCopyWith<$Res>  {
  factory $CountryModelCopyWith(CountryModel value, $Res Function(CountryModel) _then) = _$CountryModelCopyWithImpl;
@useResult
$Res call({
 String name, String? code, Map<String, String> translatedNames, String? capital, String? flagUrl, String region, String? subregion, int? population, double? latitude, double? longitude
});




}
/// @nodoc
class _$CountryModelCopyWithImpl<$Res>
    implements $CountryModelCopyWith<$Res> {
  _$CountryModelCopyWithImpl(this._self, this._then);

  final CountryModel _self;
  final $Res Function(CountryModel) _then;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? code = freezed,Object? translatedNames = null,Object? capital = freezed,Object? flagUrl = freezed,Object? region = null,Object? subregion = freezed,Object? population = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(CountryModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,translatedNames: null == translatedNames ? _self.translatedNames : translatedNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as String?,flagUrl: freezed == flagUrl ? _self.flagUrl : flagUrl // ignore: cast_nullable_to_non_nullable
as String?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,subregion: freezed == subregion ? _self.subregion : subregion // ignore: cast_nullable_to_non_nullable
as String?,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as int?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryModel].
extension CountryModelPatterns on CountryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryModel value)  $default,){
final _that = this;
switch (_that) {
case _CountryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? code,  Map<String, String> translatedNames,  String? capital,  String? flagUrl,  String region,  String? subregion,  int? population,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
return $default(_that.name,_that.code,_that.translatedNames,_that.capital,_that.flagUrl,_that.region,_that.subregion,_that.population,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? code,  Map<String, String> translatedNames,  String? capital,  String? flagUrl,  String region,  String? subregion,  int? population,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _CountryModel():
return $default(_that.name,_that.code,_that.translatedNames,_that.capital,_that.flagUrl,_that.region,_that.subregion,_that.population,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? code,  Map<String, String> translatedNames,  String? capital,  String? flagUrl,  String region,  String? subregion,  int? population,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
return $default(_that.name,_that.code,_that.translatedNames,_that.capital,_that.flagUrl,_that.region,_that.subregion,_that.population,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _CountryModel extends CountryModel {
  const _CountryModel({required this.name, required this.code,  Map<String, String> translatedNames = const {}, required this.capital, required this.flagUrl, required this.region, required this.subregion, required this.population, required this.latitude, required this.longitude}): _translatedNames = translatedNames,super._();
  

@override final  String name;
@override final  String? code;
 final  Map<String, String> _translatedNames;
@override@JsonKey() Map<String, String> get translatedNames {
  if (_translatedNames is EqualUnmodifiableMapView) return _translatedNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translatedNames);
}

@override final  String? capital;
@override final  String? flagUrl;
@override final  String region;
@override final  String? subregion;
@override final  int? population;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryModelCopyWith<_CountryModel> get copyWith => __$CountryModelCopyWithImpl<_CountryModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryModel&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._translatedNames, _translatedNames)&&(identical(other.capital, capital) || other.capital == capital)&&(identical(other.flagUrl, flagUrl) || other.flagUrl == flagUrl)&&(identical(other.region, region) || other.region == region)&&(identical(other.subregion, subregion) || other.subregion == subregion)&&(identical(other.population, population) || other.population == population)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,name,code,const DeepCollectionEquality().hash(_translatedNames),capital,flagUrl,region,subregion,population,latitude,longitude);

@override
String toString() {
  return 'CountryModel(name: $name, code: $code, translatedNames: $translatedNames, capital: $capital, flagUrl: $flagUrl, region: $region, subregion: $subregion, population: $population, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$CountryModelCopyWith<$Res> implements $CountryModelCopyWith<$Res> {
  factory _$CountryModelCopyWith(_CountryModel value, $Res Function(_CountryModel) _then) = __$CountryModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? code, Map<String, String> translatedNames, String? capital, String? flagUrl, String region, String? subregion, int? population, double? latitude, double? longitude
});




}
/// @nodoc
class __$CountryModelCopyWithImpl<$Res>
    implements _$CountryModelCopyWith<$Res> {
  __$CountryModelCopyWithImpl(this._self, this._then);

  final _CountryModel _self;
  final $Res Function(_CountryModel) _then;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? code = freezed,Object? translatedNames = null,Object? capital = freezed,Object? flagUrl = freezed,Object? region = null,Object? subregion = freezed,Object? population = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_CountryModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,translatedNames: null == translatedNames ? _self._translatedNames : translatedNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as String?,flagUrl: freezed == flagUrl ? _self.flagUrl : flagUrl // ignore: cast_nullable_to_non_nullable
as String?,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,subregion: freezed == subregion ? _self.subregion : subregion // ignore: cast_nullable_to_non_nullable
as String?,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as int?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
