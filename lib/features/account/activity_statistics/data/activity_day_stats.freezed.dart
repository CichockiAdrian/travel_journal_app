// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_day_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityDayStats {

 DateTime get date; int get photosCount; int get notesCount; int get visitedCountriesCount;
/// Create a copy of ActivityDayStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDayStatsCopyWith<ActivityDayStats> get copyWith => _$ActivityDayStatsCopyWithImpl<ActivityDayStats>(this as ActivityDayStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDayStats&&(identical(other.date, date) || other.date == date)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.visitedCountriesCount, visitedCountriesCount) || other.visitedCountriesCount == visitedCountriesCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,photosCount,notesCount,visitedCountriesCount);

@override
String toString() {
  return 'ActivityDayStats(date: $date, photosCount: $photosCount, notesCount: $notesCount, visitedCountriesCount: $visitedCountriesCount)';
}


}

/// @nodoc
abstract mixin class $ActivityDayStatsCopyWith<$Res>  {
  factory $ActivityDayStatsCopyWith(ActivityDayStats value, $Res Function(ActivityDayStats) _then) = _$ActivityDayStatsCopyWithImpl;
@useResult
$Res call({
 DateTime date, int photosCount, int notesCount, int visitedCountriesCount
});




}
/// @nodoc
class _$ActivityDayStatsCopyWithImpl<$Res>
    implements $ActivityDayStatsCopyWith<$Res> {
  _$ActivityDayStatsCopyWithImpl(this._self, this._then);

  final ActivityDayStats _self;
  final $Res Function(ActivityDayStats) _then;

/// Create a copy of ActivityDayStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? photosCount = null,Object? notesCount = null,Object? visitedCountriesCount = null,}) {
  return _then(ActivityDayStats(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,notesCount: null == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int,visitedCountriesCount: null == visitedCountriesCount ? _self.visitedCountriesCount : visitedCountriesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDayStats].
extension ActivityDayStatsPatterns on ActivityDayStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDayStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDayStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDayStats value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDayStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDayStats value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDayStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int photosCount,  int notesCount,  int visitedCountriesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDayStats() when $default != null:
return $default(_that.date,_that.photosCount,_that.notesCount,_that.visitedCountriesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int photosCount,  int notesCount,  int visitedCountriesCount)  $default,) {final _that = this;
switch (_that) {
case _ActivityDayStats():
return $default(_that.date,_that.photosCount,_that.notesCount,_that.visitedCountriesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int photosCount,  int notesCount,  int visitedCountriesCount)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDayStats() when $default != null:
return $default(_that.date,_that.photosCount,_that.notesCount,_that.visitedCountriesCount);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityDayStats extends ActivityDayStats {
  const _ActivityDayStats({required this.date, this.photosCount = 0, this.notesCount = 0, this.visitedCountriesCount = 0}): super._();
  

@override final  DateTime date;
@override@JsonKey() final  int photosCount;
@override@JsonKey() final  int notesCount;
@override@JsonKey() final  int visitedCountriesCount;

/// Create a copy of ActivityDayStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDayStatsCopyWith<_ActivityDayStats> get copyWith => __$ActivityDayStatsCopyWithImpl<_ActivityDayStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDayStats&&(identical(other.date, date) || other.date == date)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.visitedCountriesCount, visitedCountriesCount) || other.visitedCountriesCount == visitedCountriesCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,photosCount,notesCount,visitedCountriesCount);

@override
String toString() {
  return 'ActivityDayStats(date: $date, photosCount: $photosCount, notesCount: $notesCount, visitedCountriesCount: $visitedCountriesCount)';
}


}

/// @nodoc
abstract mixin class _$ActivityDayStatsCopyWith<$Res> implements $ActivityDayStatsCopyWith<$Res> {
  factory _$ActivityDayStatsCopyWith(_ActivityDayStats value, $Res Function(_ActivityDayStats) _then) = __$ActivityDayStatsCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int photosCount, int notesCount, int visitedCountriesCount
});




}
/// @nodoc
class __$ActivityDayStatsCopyWithImpl<$Res>
    implements _$ActivityDayStatsCopyWith<$Res> {
  __$ActivityDayStatsCopyWithImpl(this._self, this._then);

  final _ActivityDayStats _self;
  final $Res Function(_ActivityDayStats) _then;

/// Create a copy of ActivityDayStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? photosCount = null,Object? notesCount = null,Object? visitedCountriesCount = null,}) {
  return _then(_ActivityDayStats(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,notesCount: null == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int,visitedCountriesCount: null == visitedCountriesCount ? _self.visitedCountriesCount : visitedCountriesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
