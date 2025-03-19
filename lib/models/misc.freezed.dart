// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timing {
  DateTime get startTime;
  DateTime get endTime;

  /// Create a copy of Timing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimingCopyWith<Timing> get copyWith =>
      _$TimingCopyWithImpl<Timing>(this as Timing, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Timing &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startTime, endTime);
}

/// @nodoc
abstract mixin class $TimingCopyWith<$Res> {
  factory $TimingCopyWith(Timing value, $Res Function(Timing) _then) =
      _$TimingCopyWithImpl;
  @useResult
  $Res call({DateTime startTime, DateTime endTime});
}

/// @nodoc
class _$TimingCopyWithImpl<$Res> implements $TimingCopyWith<$Res> {
  _$TimingCopyWithImpl(this._self, this._then);

  final Timing _self;
  final $Res Function(Timing) _then;

  /// Create a copy of Timing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(Timing(
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$Subject {
  String get name;

  /// Create a copy of Subject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubjectCopyWith<Subject> get copyWith =>
      _$SubjectCopyWithImpl<Subject>(this as Subject, _$identity);

  /// Serializes this Subject to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Subject &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  @override
  String toString() {
    return 'Subject(name: $name)';
  }
}

/// @nodoc
abstract mixin class $SubjectCopyWith<$Res> {
  factory $SubjectCopyWith(Subject value, $Res Function(Subject) _then) =
      _$SubjectCopyWithImpl;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$SubjectCopyWithImpl<$Res> implements $SubjectCopyWith<$Res> {
  _$SubjectCopyWithImpl(this._self, this._then);

  final Subject _self;
  final $Res Function(Subject) _then;

  /// Create a copy of Subject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Subject extends Subject {
  const _Subject({required this.name}) : super._();
  factory _Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  @override
  final String name;

  /// Create a copy of Subject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubjectCopyWith<_Subject> get copyWith =>
      __$SubjectCopyWithImpl<_Subject>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubjectToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Subject &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  @override
  String toString() {
    return 'Subject(name: $name)';
  }
}

/// @nodoc
abstract mixin class _$SubjectCopyWith<$Res> implements $SubjectCopyWith<$Res> {
  factory _$SubjectCopyWith(_Subject value, $Res Function(_Subject) _then) =
      __$SubjectCopyWithImpl;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$SubjectCopyWithImpl<$Res> implements _$SubjectCopyWith<$Res> {
  __$SubjectCopyWithImpl(this._self, this._then);

  final _Subject _self;
  final $Res Function(_Subject) _then;

  /// Create a copy of Subject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
  }) {
    return _then(_Subject(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$Timed<T> {
  T get object;
  Timing get timing;

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimedCopyWith<T, Timed<T>> get copyWith =>
      _$TimedCopyWithImpl<T, Timed<T>>(this as Timed<T>, _$identity);

  /// Serializes this Timed to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Timed<T> &&
            const DeepCollectionEquality().equals(other.object, object) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(object), timing);

  @override
  String toString() {
    return 'Timed<$T>(object: $object, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class $TimedCopyWith<T, $Res> {
  factory $TimedCopyWith(Timed<T> value, $Res Function(Timed<T>) _then) =
      _$TimedCopyWithImpl;
  @useResult
  $Res call({T object, Timing timing});

  $TimingCopyWith<$Res> get timing;
}

/// @nodoc
class _$TimedCopyWithImpl<T, $Res> implements $TimedCopyWith<T, $Res> {
  _$TimedCopyWithImpl(this._self, this._then);

  final Timed<T> _self;
  final $Res Function(Timed<T>) _then;

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? object = freezed,
    Object? timing = null,
  }) {
    return _then(_self.copyWith(
      object: freezed == object
          ? _self.object
          : object // ignore: cast_nullable_to_non_nullable
              as T,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as Timing,
    ));
  }

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimingCopyWith<$Res> get timing {
    return $TimingCopyWith<$Res>(_self.timing, (value) {
      return _then(_self.copyWith(timing: value));
    });
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _Timed<T> implements Timed<T> {
  const _Timed({required this.object, required this.timing});
  factory _Timed.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$TimedFromJson(json, fromJsonT);

  @override
  final T object;
  @override
  final Timing timing;

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimedCopyWith<T, _Timed<T>> get copyWith =>
      __$TimedCopyWithImpl<T, _Timed<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$TimedToJson<T>(this, toJsonT);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Timed<T> &&
            const DeepCollectionEquality().equals(other.object, object) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(object), timing);

  @override
  String toString() {
    return 'Timed<$T>(object: $object, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class _$TimedCopyWith<T, $Res>
    implements $TimedCopyWith<T, $Res> {
  factory _$TimedCopyWith(_Timed<T> value, $Res Function(_Timed<T>) _then) =
      __$TimedCopyWithImpl;
  @override
  @useResult
  $Res call({T object, Timing timing});

  @override
  $TimingCopyWith<$Res> get timing;
}

/// @nodoc
class __$TimedCopyWithImpl<T, $Res> implements _$TimedCopyWith<T, $Res> {
  __$TimedCopyWithImpl(this._self, this._then);

  final _Timed<T> _self;
  final $Res Function(_Timed<T>) _then;

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? object = freezed,
    Object? timing = null,
  }) {
    return _then(_Timed<T>(
      object: freezed == object
          ? _self.object
          : object // ignore: cast_nullable_to_non_nullable
              as T,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as Timing,
    ));
  }

  /// Create a copy of Timed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimingCopyWith<$Res> get timing {
    return $TimingCopyWith<$Res>(_self.timing, (value) {
      return _then(_self.copyWith(timing: value));
    });
  }
}

/// @nodoc
mixin _$Timetable {
  List<Timing> get timings;
  Days<List<Period>> get days;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimetableCopyWith<Timetable> get copyWith =>
      _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Timetable &&
            const DeepCollectionEquality().equals(other.timings, timings) &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(timings), days);

  @override
  String toString() {
    return 'Timetable(timings: $timings, days: $days)';
  }
}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res> {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) =
      _$TimetableCopyWithImpl;
  @useResult
  $Res call({List<Timing> timings, Days<List<Period>> days});

  $DaysCopyWith<List<Period>, $Res> get days;
}

/// @nodoc
class _$TimetableCopyWithImpl<$Res> implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._self, this._then);

  final Timetable _self;
  final $Res Function(Timetable) _then;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timings = null,
    Object? days = null,
  }) {
    return _then(_self.copyWith(
      timings: null == timings
          ? _self.timings
          : timings // ignore: cast_nullable_to_non_nullable
              as List<Timing>,
      days: null == days
          ? _self.days
          : days // ignore: cast_nullable_to_non_nullable
              as Days<List<Period>>,
    ));
  }

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DaysCopyWith<List<Period>, $Res> get days {
    return $DaysCopyWith<List<Period>, $Res>(_self.days, (value) {
      return _then(_self.copyWith(days: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Timetable extends Timetable {
  const _Timetable({required final List<Timing> timings, required this.days})
      : _timings = timings,
        super._();
  factory _Timetable.fromJson(Map<String, dynamic> json) =>
      _$TimetableFromJson(json);

  final List<Timing> _timings;
  @override
  List<Timing> get timings {
    if (_timings is EqualUnmodifiableListView) return _timings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timings);
  }

  @override
  final Days<List<Period>> days;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimetableCopyWith<_Timetable> get copyWith =>
      __$TimetableCopyWithImpl<_Timetable>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TimetableToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Timetable &&
            const DeepCollectionEquality().equals(other._timings, _timings) &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_timings), days);

  @override
  String toString() {
    return 'Timetable(timings: $timings, days: $days)';
  }
}

/// @nodoc
abstract mixin class _$TimetableCopyWith<$Res>
    implements $TimetableCopyWith<$Res> {
  factory _$TimetableCopyWith(
          _Timetable value, $Res Function(_Timetable) _then) =
      __$TimetableCopyWithImpl;
  @override
  @useResult
  $Res call({List<Timing> timings, Days<List<Period>> days});

  @override
  $DaysCopyWith<List<Period>, $Res> get days;
}

/// @nodoc
class __$TimetableCopyWithImpl<$Res> implements _$TimetableCopyWith<$Res> {
  __$TimetableCopyWithImpl(this._self, this._then);

  final _Timetable _self;
  final $Res Function(_Timetable) _then;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? timings = null,
    Object? days = null,
  }) {
    return _then(_Timetable(
      timings: null == timings
          ? _self._timings
          : timings // ignore: cast_nullable_to_non_nullable
              as List<Timing>,
      days: null == days
          ? _self.days
          : days // ignore: cast_nullable_to_non_nullable
              as Days<List<Period>>,
    ));
  }

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DaysCopyWith<List<Period>, $Res> get days {
    return $DaysCopyWith<List<Period>, $Res>(_self.days, (value) {
      return _then(_self.copyWith(days: value));
    });
  }
}

Period _$PeriodFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'none':
      return PeriodNone.fromJson(json);
    case 'withSubject':
      return PeriodWithSubject.fromJson(json);
    case 'previousCombined':
      return PeriodPreviousCombined.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Period',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Period {
  /// Serializes this Period to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Period);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;
}

/// @nodoc
class $PeriodCopyWith<$Res> {
  $PeriodCopyWith(Period _, $Res Function(Period) __);
}

/// @nodoc
@JsonSerializable()
class PeriodNone implements Period {
  const PeriodNone({final String? $type}) : $type = $type ?? 'none';
  factory PeriodNone.fromJson(Map<String, dynamic> json) =>
      _$PeriodNoneFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$PeriodNoneToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PeriodNone);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;
}

/// @nodoc
@JsonSerializable()
class PeriodWithSubject implements Period {
  const PeriodWithSubject(this.subject, {final String? $type})
      : $type = $type ?? 'withSubject';
  factory PeriodWithSubject.fromJson(Map<String, dynamic> json) =>
      _$PeriodWithSubjectFromJson(json);

  final Subject subject;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of Period
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PeriodWithSubjectCopyWith<PeriodWithSubject> get copyWith =>
      _$PeriodWithSubjectCopyWithImpl<PeriodWithSubject>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PeriodWithSubjectToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PeriodWithSubject &&
            (identical(other.subject, subject) || other.subject == subject));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subject);
}

/// @nodoc
abstract mixin class $PeriodWithSubjectCopyWith<$Res>
    implements $PeriodCopyWith<$Res> {
  factory $PeriodWithSubjectCopyWith(
          PeriodWithSubject value, $Res Function(PeriodWithSubject) _then) =
      _$PeriodWithSubjectCopyWithImpl;
  @useResult
  $Res call({Subject subject});

  $SubjectCopyWith<$Res> get subject;
}

/// @nodoc
class _$PeriodWithSubjectCopyWithImpl<$Res>
    implements $PeriodWithSubjectCopyWith<$Res> {
  _$PeriodWithSubjectCopyWithImpl(this._self, this._then);

  final PeriodWithSubject _self;
  final $Res Function(PeriodWithSubject) _then;

  /// Create a copy of Period
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? subject = null,
  }) {
    return _then(PeriodWithSubject(
      null == subject
          ? _self.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as Subject,
    ));
  }

  /// Create a copy of Period
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubjectCopyWith<$Res> get subject {
    return $SubjectCopyWith<$Res>(_self.subject, (value) {
      return _then(_self.copyWith(subject: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class PeriodPreviousCombined implements Period {
  const PeriodPreviousCombined({final String? $type})
      : $type = $type ?? 'previousCombined';
  factory PeriodPreviousCombined.fromJson(Map<String, dynamic> json) =>
      _$PeriodPreviousCombinedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$PeriodPreviousCombinedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PeriodPreviousCombined);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;
}

/// @nodoc
mixin _$Days<T> {
  T get monday;
  T get tuesday;
  T get wednesday;
  T get thursday;
  T get friday;
  T get saturday;
  T get sunday;

  /// Create a copy of Days
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DaysCopyWith<T, Days<T>> get copyWith =>
      _$DaysCopyWithImpl<T, Days<T>>(this as Days<T>, _$identity);

  /// Serializes this Days to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Days<T> &&
            const DeepCollectionEquality().equals(other.monday, monday) &&
            const DeepCollectionEquality().equals(other.tuesday, tuesday) &&
            const DeepCollectionEquality().equals(other.wednesday, wednesday) &&
            const DeepCollectionEquality().equals(other.thursday, thursday) &&
            const DeepCollectionEquality().equals(other.friday, friday) &&
            const DeepCollectionEquality().equals(other.saturday, saturday) &&
            const DeepCollectionEquality().equals(other.sunday, sunday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(monday),
      const DeepCollectionEquality().hash(tuesday),
      const DeepCollectionEquality().hash(wednesday),
      const DeepCollectionEquality().hash(thursday),
      const DeepCollectionEquality().hash(friday),
      const DeepCollectionEquality().hash(saturday),
      const DeepCollectionEquality().hash(sunday));

  @override
  String toString() {
    return 'Days<$T>(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
  }
}

/// @nodoc
abstract mixin class $DaysCopyWith<T, $Res> {
  factory $DaysCopyWith(Days<T> value, $Res Function(Days<T>) _then) =
      _$DaysCopyWithImpl;
  @useResult
  $Res call(
      {T monday,
      T tuesday,
      T wednesday,
      T thursday,
      T friday,
      T saturday,
      T sunday});
}

/// @nodoc
class _$DaysCopyWithImpl<T, $Res> implements $DaysCopyWith<T, $Res> {
  _$DaysCopyWithImpl(this._self, this._then);

  final Days<T> _self;
  final $Res Function(Days<T>) _then;

  /// Create a copy of Days
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = freezed,
    Object? tuesday = freezed,
    Object? wednesday = freezed,
    Object? thursday = freezed,
    Object? friday = freezed,
    Object? saturday = freezed,
    Object? sunday = freezed,
  }) {
    return _then(_self.copyWith(
      monday: freezed == monday
          ? _self.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as T,
      tuesday: freezed == tuesday
          ? _self.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as T,
      wednesday: freezed == wednesday
          ? _self.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as T,
      thursday: freezed == thursday
          ? _self.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as T,
      friday: freezed == friday
          ? _self.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as T,
      saturday: freezed == saturday
          ? _self.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as T,
      sunday: freezed == sunday
          ? _self.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _Days<T> extends Days<T> {
  _Days(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday})
      : super._();
  factory _Days.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$DaysFromJson(json, fromJsonT);

  @override
  final T monday;
  @override
  final T tuesday;
  @override
  final T wednesday;
  @override
  final T thursday;
  @override
  final T friday;
  @override
  final T saturday;
  @override
  final T sunday;

  /// Create a copy of Days
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DaysCopyWith<T, _Days<T>> get copyWith =>
      __$DaysCopyWithImpl<T, _Days<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$DaysToJson<T>(this, toJsonT);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Days<T> &&
            const DeepCollectionEquality().equals(other.monday, monday) &&
            const DeepCollectionEquality().equals(other.tuesday, tuesday) &&
            const DeepCollectionEquality().equals(other.wednesday, wednesday) &&
            const DeepCollectionEquality().equals(other.thursday, thursday) &&
            const DeepCollectionEquality().equals(other.friday, friday) &&
            const DeepCollectionEquality().equals(other.saturday, saturday) &&
            const DeepCollectionEquality().equals(other.sunday, sunday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(monday),
      const DeepCollectionEquality().hash(tuesday),
      const DeepCollectionEquality().hash(wednesday),
      const DeepCollectionEquality().hash(thursday),
      const DeepCollectionEquality().hash(friday),
      const DeepCollectionEquality().hash(saturday),
      const DeepCollectionEquality().hash(sunday));

  @override
  String toString() {
    return 'Days<$T>(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
  }
}

/// @nodoc
abstract mixin class _$DaysCopyWith<T, $Res> implements $DaysCopyWith<T, $Res> {
  factory _$DaysCopyWith(_Days<T> value, $Res Function(_Days<T>) _then) =
      __$DaysCopyWithImpl;
  @override
  @useResult
  $Res call(
      {T monday,
      T tuesday,
      T wednesday,
      T thursday,
      T friday,
      T saturday,
      T sunday});
}

/// @nodoc
class __$DaysCopyWithImpl<T, $Res> implements _$DaysCopyWith<T, $Res> {
  __$DaysCopyWithImpl(this._self, this._then);

  final _Days<T> _self;
  final $Res Function(_Days<T>) _then;

  /// Create a copy of Days
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? monday = freezed,
    Object? tuesday = freezed,
    Object? wednesday = freezed,
    Object? thursday = freezed,
    Object? friday = freezed,
    Object? saturday = freezed,
    Object? sunday = freezed,
  }) {
    return _then(_Days<T>(
      monday: freezed == monday
          ? _self.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as T,
      tuesday: freezed == tuesday
          ? _self.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as T,
      wednesday: freezed == wednesday
          ? _self.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as T,
      thursday: freezed == thursday
          ? _self.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as T,
      friday: freezed == friday
          ? _self.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as T,
      saturday: freezed == saturday
          ? _self.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as T,
      sunday: freezed == sunday
          ? _self.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

// dart format on
