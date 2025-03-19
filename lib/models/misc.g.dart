// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timing _$TimingFromJson(Map<String, dynamic> json) => Timing(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$TimingToJson(Timing instance) => <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };

_Subject _$SubjectFromJson(Map<String, dynamic> json) => _Subject(
      name: json['name'] as String,
    );

Map<String, dynamic> _$SubjectToJson(_Subject instance) => <String, dynamic>{
      'name': instance.name,
    };

_Timed<T> _$TimedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _Timed<T>(
      object: fromJsonT(json['object']),
      timing: Timing.fromJson(json['timing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimedToJson<T>(
  _Timed<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'object': toJsonT(instance.object),
      'timing': instance.timing.toJson(),
    };

_Timetable _$TimetableFromJson(Map<String, dynamic> json) => _Timetable(
      timings: (json['timings'] as List<dynamic>)
          .map((e) => Timing.fromJson(e as Map<String, dynamic>))
          .toList(),
      days: Days<List<Period>>.fromJson(
          json['days'] as Map<String, dynamic>,
          (value) => (value as List<dynamic>)
              .map((e) => Period.fromJson(e as Map<String, dynamic>))
              .toList()),
    );

Map<String, dynamic> _$TimetableToJson(_Timetable instance) =>
    <String, dynamic>{
      'timings': instance.timings.map((e) => e.toJson()).toList(),
      'days': instance.days.toJson(
        (value) => value.map((e) => e.toJson()).toList(),
      ),
    };

PeriodNone _$PeriodNoneFromJson(Map<String, dynamic> json) => PeriodNone(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PeriodNoneToJson(PeriodNone instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

PeriodWithSubject _$PeriodWithSubjectFromJson(Map<String, dynamic> json) =>
    PeriodWithSubject(
      Subject.fromJson(json['subject'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PeriodWithSubjectToJson(PeriodWithSubject instance) =>
    <String, dynamic>{
      'subject': instance.subject.toJson(),
      'runtimeType': instance.$type,
    };

PeriodPreviousCombined _$PeriodPreviousCombinedFromJson(
        Map<String, dynamic> json) =>
    PeriodPreviousCombined(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PeriodPreviousCombinedToJson(
        PeriodPreviousCombined instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_Days<T> _$DaysFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _Days<T>(
      monday: fromJsonT(json['monday']),
      tuesday: fromJsonT(json['tuesday']),
      wednesday: fromJsonT(json['wednesday']),
      thursday: fromJsonT(json['thursday']),
      friday: fromJsonT(json['friday']),
      saturday: fromJsonT(json['saturday']),
      sunday: fromJsonT(json['sunday']),
    );

Map<String, dynamic> _$DaysToJson<T>(
  _Days<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'monday': toJsonT(instance.monday),
      'tuesday': toJsonT(instance.tuesday),
      'wednesday': toJsonT(instance.wednesday),
      'thursday': toJsonT(instance.thursday),
      'friday': toJsonT(instance.friday),
      'saturday': toJsonT(instance.saturday),
      'sunday': toJsonT(instance.sunday),
    };
