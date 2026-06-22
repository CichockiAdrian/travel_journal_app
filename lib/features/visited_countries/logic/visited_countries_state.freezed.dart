// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visited_countries_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisitedCountriesState {

 VisitedCountriesStatus get status; List<VisitedCountryModel> get visitedCountries; bool get isUpdatingVisitedCountry; VisitedCountriesFailureType? get failureType;
/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitedCountriesStateCopyWith<VisitedCountriesState> get copyWith => _$VisitedCountriesStateCopyWithImpl<VisitedCountriesState>(this as VisitedCountriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitedCountriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.visitedCountries, visitedCountries)&&(identical(other.isUpdatingVisitedCountry, isUpdatingVisitedCountry) || other.isUpdatingVisitedCountry == isUpdatingVisitedCountry)&&(identical(other.failureType, failureType) || other.failureType == failureType));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(visitedCountries),isUpdatingVisitedCountry,failureType);

@override
String toString() {
  return 'VisitedCountriesState(status: $status, visitedCountries: $visitedCountries, isUpdatingVisitedCountry: $isUpdatingVisitedCountry, failureType: $failureType)';
}


}

/// @nodoc
abstract mixin class $VisitedCountriesStateCopyWith<$Res>  {
  factory $VisitedCountriesStateCopyWith(VisitedCountriesState value, $Res Function(VisitedCountriesState) _then) = _$VisitedCountriesStateCopyWithImpl;
@useResult
$Res call({
 VisitedCountriesStatus status, List<VisitedCountryModel> visitedCountries, bool isUpdatingVisitedCountry, VisitedCountriesFailureType? failureType
});




}
/// @nodoc
class _$VisitedCountriesStateCopyWithImpl<$Res>
    implements $VisitedCountriesStateCopyWith<$Res> {
  _$VisitedCountriesStateCopyWithImpl(this._self, this._then);

  final VisitedCountriesState _self;
  final $Res Function(VisitedCountriesState) _then;

/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? visitedCountries = null,Object? isUpdatingVisitedCountry = null,Object? failureType = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VisitedCountriesStatus,visitedCountries: null == visitedCountries ? _self.visitedCountries : visitedCountries // ignore: cast_nullable_to_non_nullable
as List<VisitedCountryModel>,isUpdatingVisitedCountry: null == isUpdatingVisitedCountry ? _self.isUpdatingVisitedCountry : isUpdatingVisitedCountry // ignore: cast_nullable_to_non_nullable
as bool,failureType: freezed == failureType ? _self.failureType : failureType // ignore: cast_nullable_to_non_nullable
as VisitedCountriesFailureType?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitedCountriesState].
extension VisitedCountriesStatePatterns on VisitedCountriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitedCountriesState value)?  $default,{TResult Function( _InitialVisitedCountriesState value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitedCountriesState() when $default != null:
return $default(_that);case _InitialVisitedCountriesState() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitedCountriesState value)  $default,{required TResult Function( _InitialVisitedCountriesState value)  initial,}){
final _that = this;
switch (_that) {
case _VisitedCountriesState():
return $default(_that);case _InitialVisitedCountriesState():
return initial(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitedCountriesState value)?  $default,{TResult? Function( _InitialVisitedCountriesState value)?  initial,}){
final _that = this;
switch (_that) {
case _VisitedCountriesState() when $default != null:
return $default(_that);case _InitialVisitedCountriesState() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)?  $default,{TResult Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)?  initial,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitedCountriesState() when $default != null:
return $default(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _InitialVisitedCountriesState() when initial != null:
return initial(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)  $default,{required TResult Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)  initial,}) {final _that = this;
switch (_that) {
case _VisitedCountriesState():
return $default(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _InitialVisitedCountriesState():
return initial(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)?  $default,{TResult? Function( VisitedCountriesStatus status,  List<VisitedCountryModel> visitedCountries,  bool isUpdatingVisitedCountry,  VisitedCountriesFailureType? failureType)?  initial,}) {final _that = this;
switch (_that) {
case _VisitedCountriesState() when $default != null:
return $default(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _InitialVisitedCountriesState() when initial != null:
return initial(_that.status,_that.visitedCountries,_that.isUpdatingVisitedCountry,_that.failureType);case _:
  return null;

}
}

}

/// @nodoc


class _VisitedCountriesState extends VisitedCountriesState {
  const _VisitedCountriesState({required this.status,  List<VisitedCountryModel> visitedCountries = const [], this.isUpdatingVisitedCountry = false, this.failureType}): _visitedCountries = visitedCountries,super._();
  

@override final  VisitedCountriesStatus status;
 final  List<VisitedCountryModel> _visitedCountries;
@override@JsonKey() List<VisitedCountryModel> get visitedCountries {
  if (_visitedCountries is EqualUnmodifiableListView) return _visitedCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visitedCountries);
}

@override@JsonKey() final  bool isUpdatingVisitedCountry;
@override final  VisitedCountriesFailureType? failureType;

/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitedCountriesStateCopyWith<_VisitedCountriesState> get copyWith => __$VisitedCountriesStateCopyWithImpl<_VisitedCountriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitedCountriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._visitedCountries, _visitedCountries)&&(identical(other.isUpdatingVisitedCountry, isUpdatingVisitedCountry) || other.isUpdatingVisitedCountry == isUpdatingVisitedCountry)&&(identical(other.failureType, failureType) || other.failureType == failureType));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_visitedCountries),isUpdatingVisitedCountry,failureType);

@override
String toString() {
  return 'VisitedCountriesState(status: $status, visitedCountries: $visitedCountries, isUpdatingVisitedCountry: $isUpdatingVisitedCountry, failureType: $failureType)';
}


}

/// @nodoc
abstract mixin class _$VisitedCountriesStateCopyWith<$Res> implements $VisitedCountriesStateCopyWith<$Res> {
  factory _$VisitedCountriesStateCopyWith(_VisitedCountriesState value, $Res Function(_VisitedCountriesState) _then) = __$VisitedCountriesStateCopyWithImpl;
@override @useResult
$Res call({
 VisitedCountriesStatus status, List<VisitedCountryModel> visitedCountries, bool isUpdatingVisitedCountry, VisitedCountriesFailureType? failureType
});




}
/// @nodoc
class __$VisitedCountriesStateCopyWithImpl<$Res>
    implements _$VisitedCountriesStateCopyWith<$Res> {
  __$VisitedCountriesStateCopyWithImpl(this._self, this._then);

  final _VisitedCountriesState _self;
  final $Res Function(_VisitedCountriesState) _then;

/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? visitedCountries = null,Object? isUpdatingVisitedCountry = null,Object? failureType = freezed,}) {
  return _then(_VisitedCountriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VisitedCountriesStatus,visitedCountries: null == visitedCountries ? _self._visitedCountries : visitedCountries // ignore: cast_nullable_to_non_nullable
as List<VisitedCountryModel>,isUpdatingVisitedCountry: null == isUpdatingVisitedCountry ? _self.isUpdatingVisitedCountry : isUpdatingVisitedCountry // ignore: cast_nullable_to_non_nullable
as bool,failureType: freezed == failureType ? _self.failureType : failureType // ignore: cast_nullable_to_non_nullable
as VisitedCountriesFailureType?,
  ));
}


}

/// @nodoc


class _InitialVisitedCountriesState extends VisitedCountriesState {
  const _InitialVisitedCountriesState({this.status = VisitedCountriesStatus.initial,  List<VisitedCountryModel> visitedCountries = const [], this.isUpdatingVisitedCountry = false, this.failureType}): _visitedCountries = visitedCountries,super._();
  

@override@JsonKey() final  VisitedCountriesStatus status;
 final  List<VisitedCountryModel> _visitedCountries;
@override@JsonKey() List<VisitedCountryModel> get visitedCountries {
  if (_visitedCountries is EqualUnmodifiableListView) return _visitedCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visitedCountries);
}

@override@JsonKey() final  bool isUpdatingVisitedCountry;
@override final  VisitedCountriesFailureType? failureType;

/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialVisitedCountriesStateCopyWith<_InitialVisitedCountriesState> get copyWith => __$InitialVisitedCountriesStateCopyWithImpl<_InitialVisitedCountriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialVisitedCountriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._visitedCountries, _visitedCountries)&&(identical(other.isUpdatingVisitedCountry, isUpdatingVisitedCountry) || other.isUpdatingVisitedCountry == isUpdatingVisitedCountry)&&(identical(other.failureType, failureType) || other.failureType == failureType));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_visitedCountries),isUpdatingVisitedCountry,failureType);

@override
String toString() {
  return 'VisitedCountriesState.initial(status: $status, visitedCountries: $visitedCountries, isUpdatingVisitedCountry: $isUpdatingVisitedCountry, failureType: $failureType)';
}


}

/// @nodoc
abstract mixin class _$InitialVisitedCountriesStateCopyWith<$Res> implements $VisitedCountriesStateCopyWith<$Res> {
  factory _$InitialVisitedCountriesStateCopyWith(_InitialVisitedCountriesState value, $Res Function(_InitialVisitedCountriesState) _then) = __$InitialVisitedCountriesStateCopyWithImpl;
@override @useResult
$Res call({
 VisitedCountriesStatus status, List<VisitedCountryModel> visitedCountries, bool isUpdatingVisitedCountry, VisitedCountriesFailureType? failureType
});




}
/// @nodoc
class __$InitialVisitedCountriesStateCopyWithImpl<$Res>
    implements _$InitialVisitedCountriesStateCopyWith<$Res> {
  __$InitialVisitedCountriesStateCopyWithImpl(this._self, this._then);

  final _InitialVisitedCountriesState _self;
  final $Res Function(_InitialVisitedCountriesState) _then;

/// Create a copy of VisitedCountriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? visitedCountries = null,Object? isUpdatingVisitedCountry = null,Object? failureType = freezed,}) {
  return _then(_InitialVisitedCountriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VisitedCountriesStatus,visitedCountries: null == visitedCountries ? _self._visitedCountries : visitedCountries // ignore: cast_nullable_to_non_nullable
as List<VisitedCountryModel>,isUpdatingVisitedCountry: null == isUpdatingVisitedCountry ? _self.isUpdatingVisitedCountry : isUpdatingVisitedCountry // ignore: cast_nullable_to_non_nullable
as bool,failureType: freezed == failureType ? _self.failureType : failureType // ignore: cast_nullable_to_non_nullable
as VisitedCountriesFailureType?,
  ));
}


}

// dart format on
