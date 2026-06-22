// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_diary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TripDiaryState {

 TripDiaryStatus get status; List<TripDiaryEntry> get entries; String? get errorMessage;
/// Create a copy of TripDiaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDiaryStateCopyWith<TripDiaryState> get copyWith => _$TripDiaryStateCopyWithImpl<TripDiaryState>(this as TripDiaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDiaryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(entries),errorMessage);

@override
String toString() {
  return 'TripDiaryState(status: $status, entries: $entries, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TripDiaryStateCopyWith<$Res>  {
  factory $TripDiaryStateCopyWith(TripDiaryState value, $Res Function(TripDiaryState) _then) = _$TripDiaryStateCopyWithImpl;
@useResult
$Res call({
 TripDiaryStatus status, List<TripDiaryEntry> entries, String? errorMessage
});




}
/// @nodoc
class _$TripDiaryStateCopyWithImpl<$Res>
    implements $TripDiaryStateCopyWith<$Res> {
  _$TripDiaryStateCopyWithImpl(this._self, this._then);

  final TripDiaryState _self;
  final $Res Function(TripDiaryState) _then;

/// Create a copy of TripDiaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? entries = null,Object? errorMessage = freezed,}) {
  return _then(TripDiaryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripDiaryStatus,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<TripDiaryEntry>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripDiaryState].
extension TripDiaryStatePatterns on TripDiaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDiaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDiaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDiaryState value)  $default,){
final _that = this;
switch (_that) {
case _TripDiaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDiaryState value)?  $default,){
final _that = this;
switch (_that) {
case _TripDiaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TripDiaryStatus status,  List<TripDiaryEntry> entries,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDiaryState() when $default != null:
return $default(_that.status,_that.entries,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TripDiaryStatus status,  List<TripDiaryEntry> entries,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TripDiaryState():
return $default(_that.status,_that.entries,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TripDiaryStatus status,  List<TripDiaryEntry> entries,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TripDiaryState() when $default != null:
return $default(_that.status,_that.entries,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TripDiaryState extends TripDiaryState {
  const _TripDiaryState({this.status = TripDiaryStatus.initial,  List<TripDiaryEntry> entries = const <TripDiaryEntry>[], this.errorMessage}): _entries = entries,super._();
  

@override@JsonKey() final  TripDiaryStatus status;
 final  List<TripDiaryEntry> _entries;
@override@JsonKey() List<TripDiaryEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  String? errorMessage;

/// Create a copy of TripDiaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDiaryStateCopyWith<_TripDiaryState> get copyWith => __$TripDiaryStateCopyWithImpl<_TripDiaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDiaryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_entries),errorMessage);

@override
String toString() {
  return 'TripDiaryState(status: $status, entries: $entries, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TripDiaryStateCopyWith<$Res> implements $TripDiaryStateCopyWith<$Res> {
  factory _$TripDiaryStateCopyWith(_TripDiaryState value, $Res Function(_TripDiaryState) _then) = __$TripDiaryStateCopyWithImpl;
@override @useResult
$Res call({
 TripDiaryStatus status, List<TripDiaryEntry> entries, String? errorMessage
});




}
/// @nodoc
class __$TripDiaryStateCopyWithImpl<$Res>
    implements _$TripDiaryStateCopyWith<$Res> {
  __$TripDiaryStateCopyWithImpl(this._self, this._then);

  final _TripDiaryState _self;
  final $Res Function(_TripDiaryState) _then;

/// Create a copy of TripDiaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? entries = null,Object? errorMessage = freezed,}) {
  return _then(_TripDiaryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripDiaryStatus,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<TripDiaryEntry>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
