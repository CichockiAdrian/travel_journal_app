// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_activity_stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileActivityStatsState {

 ProfileActivityStatsStatus get status; ProfileActivityStats get stats; String? get errorMessage;
/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileActivityStatsStateCopyWith<ProfileActivityStatsState> get copyWith => _$ProfileActivityStatsStateCopyWithImpl<ProfileActivityStatsState>(this as ProfileActivityStatsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileActivityStatsState&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,stats,errorMessage);

@override
String toString() {
  return 'ProfileActivityStatsState(status: $status, stats: $stats, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileActivityStatsStateCopyWith<$Res>  {
  factory $ProfileActivityStatsStateCopyWith(ProfileActivityStatsState value, $Res Function(ProfileActivityStatsState) _then) = _$ProfileActivityStatsStateCopyWithImpl;
@useResult
$Res call({
 ProfileActivityStatsStatus status, ProfileActivityStats stats, String? errorMessage
});


$ProfileActivityStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$ProfileActivityStatsStateCopyWithImpl<$Res>
    implements $ProfileActivityStatsStateCopyWith<$Res> {
  _$ProfileActivityStatsStateCopyWithImpl(this._self, this._then);

  final ProfileActivityStatsState _self;
  final $Res Function(ProfileActivityStatsState) _then;

/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? stats = null,Object? errorMessage = freezed,}) {
  return _then(ProfileActivityStatsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileActivityStatsStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ProfileActivityStats,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileActivityStatsCopyWith<$Res> get stats {
  
  return $ProfileActivityStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileActivityStatsState].
extension ProfileActivityStatsStatePatterns on ProfileActivityStatsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileActivityStatsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileActivityStatsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileActivityStatsState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileActivityStatsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileActivityStatsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileActivityStatsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileActivityStatsStatus status,  ProfileActivityStats stats,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileActivityStatsState() when $default != null:
return $default(_that.status,_that.stats,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileActivityStatsStatus status,  ProfileActivityStats stats,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileActivityStatsState():
return $default(_that.status,_that.stats,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileActivityStatsStatus status,  ProfileActivityStats stats,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileActivityStatsState() when $default != null:
return $default(_that.status,_that.stats,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileActivityStatsState extends ProfileActivityStatsState {
  const _ProfileActivityStatsState({this.status = ProfileActivityStatsStatus.initial, this.stats = const ProfileActivityStats(), this.errorMessage}): super._();
  

@override@JsonKey() final  ProfileActivityStatsStatus status;
@override@JsonKey() final  ProfileActivityStats stats;
@override final  String? errorMessage;

/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileActivityStatsStateCopyWith<_ProfileActivityStatsState> get copyWith => __$ProfileActivityStatsStateCopyWithImpl<_ProfileActivityStatsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileActivityStatsState&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,stats,errorMessage);

@override
String toString() {
  return 'ProfileActivityStatsState(status: $status, stats: $stats, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileActivityStatsStateCopyWith<$Res> implements $ProfileActivityStatsStateCopyWith<$Res> {
  factory _$ProfileActivityStatsStateCopyWith(_ProfileActivityStatsState value, $Res Function(_ProfileActivityStatsState) _then) = __$ProfileActivityStatsStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileActivityStatsStatus status, ProfileActivityStats stats, String? errorMessage
});


@override $ProfileActivityStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$ProfileActivityStatsStateCopyWithImpl<$Res>
    implements _$ProfileActivityStatsStateCopyWith<$Res> {
  __$ProfileActivityStatsStateCopyWithImpl(this._self, this._then);

  final _ProfileActivityStatsState _self;
  final $Res Function(_ProfileActivityStatsState) _then;

/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? stats = null,Object? errorMessage = freezed,}) {
  return _then(_ProfileActivityStatsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileActivityStatsStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ProfileActivityStats,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileActivityStatsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileActivityStatsCopyWith<$Res> get stats {
  
  return $ProfileActivityStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
