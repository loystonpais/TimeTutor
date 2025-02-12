// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes.dart';

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

StandardTimeTable _$StandardTimeTableFromJson(Map<String, dynamic> json) =>
    StandardTimeTable(
      timings: (json['timings'] as List<dynamic>)
          .map((e) => Timing.fromJson(e as Map<String, dynamic>))
          .toList(),
      days: Days<List<String>>.fromJson(json['days'] as Map<String, dynamic>,
          (value) => (value as List<dynamic>).map((e) => e as String).toList()),
    );

Map<String, dynamic> _$StandardTimeTableToJson(StandardTimeTable instance) =>
    <String, dynamic>{
      'timings': instance.timings.map((e) => e.toJson()).toList(),
      'days': instance.days.toJson(
        (value) => value,
      ),
    };

Days<T> _$DaysMapFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Days<T>(
      monday: fromJsonT(json['monday']),
      tuesday: fromJsonT(json['tuesday']),
      wednesday: fromJsonT(json['wednesday']),
      thursday: fromJsonT(json['thursday']),
      friday: fromJsonT(json['friday']),
      saturday: fromJsonT(json['saturday']),
      sunday: fromJsonT(json['sunday']),
    );

Map<String, dynamic> _$DaysMapToJson<T>(
  Days<T> instance,
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
