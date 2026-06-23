// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_activity_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileActivityStats {

 int get currentStreak; int get longestStreak; int get activeDaysCount; int get photosCount; int get notesCount; int get visitedCountriesCount; List<ActivityDayStats> get dailyStats;
/// Create a copy of ProfileActivityStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileActivityStatsCopyWith<ProfileActivityStats> get copyWith => _$ProfileActivityStatsCopyWithImpl<ProfileActivityStats>(this as ProfileActivityStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileActivityStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.activeDaysCount, activeDaysCount) || other.activeDaysCount == activeDaysCount)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.visitedCountriesCount, visitedCountriesCount) || other.visitedCountriesCount == visitedCountriesCount)&&const DeepCollectionEquality().equals(other.dailyStats, dailyStats));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,activeDaysCount,photosCount,notesCount,visitedCountriesCount,const DeepCollectionEquality().hash(dailyStats));

@override
String toString() {
  return 'ProfileActivityStats(currentStreak: $currentStreak, longestStreak: $longestStreak, activeDaysCount: $activeDaysCount, photosCount: $photosCount, notesCount: $notesCount, visitedCountriesCount: $visitedCountriesCount, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class $ProfileActivityStatsCopyWith<$Res>  {
  factory $ProfileActivityStatsCopyWith(ProfileActivityStats value, $Res Function(ProfileActivityStats) _then) = _$ProfileActivityStatsCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int longestStreak, int activeDaysCount, int photosCount, int notesCount, int visitedCountriesCount, List<ActivityDayStats> dailyStats
});




}
/// @nodoc
class _$ProfileActivityStatsCopyWithImpl<$Res>
    implements $ProfileActivityStatsCopyWith<$Res> {
  _$ProfileActivityStatsCopyWithImpl(this._self, this._then);

  final ProfileActivityStats _self;
  final $Res Function(ProfileActivityStats) _then;

/// Create a copy of ProfileActivityStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? activeDaysCount = null,Object? photosCount = null,Object? notesCount = null,Object? visitedCountriesCount = null,Object? dailyStats = null,}) {
  return _then(ProfileActivityStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,activeDaysCount: null == activeDaysCount ? _self.activeDaysCount : activeDaysCount // ignore: cast_nullable_to_non_nullable
as int,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,notesCount: null == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int,visitedCountriesCount: null == visitedCountriesCount ? _self.visitedCountriesCount : visitedCountriesCount // ignore: cast_nullable_to_non_nullable
as int,dailyStats: null == dailyStats ? _self.dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<ActivityDayStats>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileActivityStats].
extension ProfileActivityStatsPatterns on ProfileActivityStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileActivityStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileActivityStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileActivityStats value)  $default,){
final _that = this;
switch (_that) {
case _ProfileActivityStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileActivityStats value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileActivityStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int activeDaysCount,  int photosCount,  int notesCount,  int visitedCountriesCount,  List<ActivityDayStats> dailyStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileActivityStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.activeDaysCount,_that.photosCount,_that.notesCount,_that.visitedCountriesCount,_that.dailyStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int activeDaysCount,  int photosCount,  int notesCount,  int visitedCountriesCount,  List<ActivityDayStats> dailyStats)  $default,) {final _that = this;
switch (_that) {
case _ProfileActivityStats():
return $default(_that.currentStreak,_that.longestStreak,_that.activeDaysCount,_that.photosCount,_that.notesCount,_that.visitedCountriesCount,_that.dailyStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int longestStreak,  int activeDaysCount,  int photosCount,  int notesCount,  int visitedCountriesCount,  List<ActivityDayStats> dailyStats)?  $default,) {final _that = this;
switch (_that) {
case _ProfileActivityStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.activeDaysCount,_that.photosCount,_that.notesCount,_that.visitedCountriesCount,_that.dailyStats);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileActivityStats extends ProfileActivityStats {
  const _ProfileActivityStats({this.currentStreak = 0, this.longestStreak = 0, this.activeDaysCount = 0, this.photosCount = 0, this.notesCount = 0, this.visitedCountriesCount = 0,  List<ActivityDayStats> dailyStats = const <ActivityDayStats>[]}): _dailyStats = dailyStats,super._();
  

@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  int activeDaysCount;
@override@JsonKey() final  int photosCount;
@override@JsonKey() final  int notesCount;
@override@JsonKey() final  int visitedCountriesCount;
 final  List<ActivityDayStats> _dailyStats;
@override@JsonKey() List<ActivityDayStats> get dailyStats {
  if (_dailyStats is EqualUnmodifiableListView) return _dailyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyStats);
}


/// Create a copy of ProfileActivityStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileActivityStatsCopyWith<_ProfileActivityStats> get copyWith => __$ProfileActivityStatsCopyWithImpl<_ProfileActivityStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileActivityStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.activeDaysCount, activeDaysCount) || other.activeDaysCount == activeDaysCount)&&(identical(other.photosCount, photosCount) || other.photosCount == photosCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.visitedCountriesCount, visitedCountriesCount) || other.visitedCountriesCount == visitedCountriesCount)&&const DeepCollectionEquality().equals(other._dailyStats, _dailyStats));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,activeDaysCount,photosCount,notesCount,visitedCountriesCount,const DeepCollectionEquality().hash(_dailyStats));

@override
String toString() {
  return 'ProfileActivityStats(currentStreak: $currentStreak, longestStreak: $longestStreak, activeDaysCount: $activeDaysCount, photosCount: $photosCount, notesCount: $notesCount, visitedCountriesCount: $visitedCountriesCount, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class _$ProfileActivityStatsCopyWith<$Res> implements $ProfileActivityStatsCopyWith<$Res> {
  factory _$ProfileActivityStatsCopyWith(_ProfileActivityStats value, $Res Function(_ProfileActivityStats) _then) = __$ProfileActivityStatsCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int longestStreak, int activeDaysCount, int photosCount, int notesCount, int visitedCountriesCount, List<ActivityDayStats> dailyStats
});




}
/// @nodoc
class __$ProfileActivityStatsCopyWithImpl<$Res>
    implements _$ProfileActivityStatsCopyWith<$Res> {
  __$ProfileActivityStatsCopyWithImpl(this._self, this._then);

  final _ProfileActivityStats _self;
  final $Res Function(_ProfileActivityStats) _then;

/// Create a copy of ProfileActivityStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? activeDaysCount = null,Object? photosCount = null,Object? notesCount = null,Object? visitedCountriesCount = null,Object? dailyStats = null,}) {
  return _then(_ProfileActivityStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,activeDaysCount: null == activeDaysCount ? _self.activeDaysCount : activeDaysCount // ignore: cast_nullable_to_non_nullable
as int,photosCount: null == photosCount ? _self.photosCount : photosCount // ignore: cast_nullable_to_non_nullable
as int,notesCount: null == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int,visitedCountriesCount: null == visitedCountriesCount ? _self.visitedCountriesCount : visitedCountriesCount // ignore: cast_nullable_to_non_nullable
as int,dailyStats: null == dailyStats ? _self._dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<ActivityDayStats>,
  ));
}


}

// dart format on
