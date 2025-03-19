import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/extensions/extensions.dart';

part 'misc.g.dart';

part 'misc.freezed.dart';

@JsonSerializable()
@freezed
class Timing with _$Timing {
  final DateTime startTime;
  final DateTime endTime;

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);

  Map<String, dynamic> toJson() => _$TimingToJson(this);

  Timing({required this.startTime, required this.endTime});

  @override
  String toString() {
    return "${startTime.toTimeOfDay().toHumanReadableString()}-${endTime.toTimeOfDay().toHumanReadableString()}";
  }

  String toHumanReadableString() => toString();

  factory Timing.fromHumanReadableString(String string) {
    final String start;
    final String end;
    try {
      start = string.split("-")[0];
      end = string.split("-")[1];
      print(start);
    } catch (e) {
      throw Exception("Unable to parse $string");
    }

    final TimeOfDay startTod;
    final TimeOfDay endTod;

    try {
      startTod = start.toTimeOfDayFromHumanReadable();
      endTod = end.toTimeOfDayFromHumanReadable();
    } catch (e) {
      throw Exception("At $string : $e");
    }

    return Timing(startTime: startTod.toDateTime(), endTime: endTod.toDateTime());
  }
}

@Freezed()
sealed class Subject with _$Subject {
  const Subject._();

  const factory Subject({required String name}) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  factory Subject.fromString(String string) => Subject(name: string);

  Period toPeriod() {
    return Period.withSubject(this);
  }
}

@Freezed(genericArgumentFactories: true)
sealed class Timed<T> with _$Timed<T> {
  const factory Timed({required T object, required Timing timing}) = _Timed;

  factory Timed.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$TimedFromJson(json, fromJsonT);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => throw UnimplementedError;
}

@Freezed()
sealed class Timetable with _$Timetable {
  const Timetable._();

  const factory Timetable({required List<Timing> timings, required Days<List<Period>> days}) = _Timetable;

  Days<List<Timed<PeriodWithSubject>>> get dayWithPeriods {
    return Days<List<Timed<PeriodWithSubject>>>(
      sunday: days.sunday.toTimedPeriods(timings),
      monday: days.monday.toTimedPeriods(timings),
      tuesday: days.tuesday.toTimedPeriods(timings),
      wednesday: days.wednesday.toTimedPeriods(timings),
      thursday: days.thursday.toTimedPeriods(timings),
      friday: days.friday.toTimedPeriods(timings),
      saturday: days.saturday.toTimedPeriods(timings),
    );
  }

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);

  Map<String, dynamic> toEasyJson() {
    final Map<String, dynamic> easyJson = {};

    easyJson["days"] = days.asList.asMap().map<String, List<String>>(
          (key, value) => MapEntry(
            value.$1.small,
            value.$2.map((e) => Period.humanReadableStringOf(e)).toList(),
          ),
        );
    easyJson["timings"] = timings.map<String>((e) => e.toString()).toList();

    return easyJson;
  }

  factory Timetable.fromEasyJson(Map<String, dynamic> json) {
    if (!json.containsKey("timings")) {
      throw Exception("Failed to parse, no timings are given");
    }

    List<Timing> timings = [];
    for (final String timingString in json["timings"]) {
      print(timingString);
      timings.add(timingString.toTimingFromHumanReadable());
    }

    if (!json.containsKey("days")) {
      throw Exception("Failed to parse, no days are given");
    }

    // Validate that the "days" value is a Map.
    final daysJson = json["days"];
    if (daysJson is! Map<String, dynamic>) {
      throw Exception("Failed to parse, 'days' should be a map");
    }

    // Define the allowed day keys.
    final allowedDays = {
      Day.sunday.small,
      Day.monday.small,
      Day.tuesday.small,
      Day.wednesday.small,
      Day.thursday.small,
      Day.friday.small,
      Day.saturday.small,
    };

    // Check for any invalid keys.
    for (final key in daysJson.keys) {
      if (!allowedDays.contains(key)) {
        throw Exception("Invalid day key found in 'days': $key");
      }
    }

    var sunday = ((daysJson[Day.sunday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var monday = ((daysJson[Day.monday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var tuesday = ((daysJson[Day.tuesday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var wednesday =
        ((daysJson[Day.wednesday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var thursday =
        ((daysJson[Day.thursday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var friday = ((daysJson[Day.friday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();
    var saturday =
        ((daysJson[Day.saturday.small] as List<dynamic>?)?.cast<String>() ?? <String>[]).map((e) => Period.fromString(e)).toList();

    var days = Days<List<Period>>(
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
    );

    final timetable = Timetable(days: days, timings: timings);
    final daysWithPeriods = timetable.dayWithPeriods;

    return timetable;
  }
}

@freezed
sealed class Period with _$Period {
  const factory Period.none() = PeriodNone;
  const factory Period.withSubject(Subject subject) = PeriodWithSubject;
  const factory Period.previousCombined() = PeriodPreviousCombined;

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  @override
  String toString() {
    return humanReadableStringOf(this);
  }

  static String humanReadableStringOf(Period period) {
    if (period is PeriodNone) return "~none";
    if (period is PeriodPreviousCombined) return "~prev";
    return (period as PeriodWithSubject).subject.name;
  }

  factory Period.fromString(String string) {
    switch (string) {
      case "~none":
        return Period.none();
      case "~prev":
        return Period.previousCombined();
      default:
        return Period.withSubject(Subject(name: string));
    }
  }
}

enum Day {
  sunday(name: "Sunday", short: "Sun", small: "sunday"),
  monday(name: "Monday", short: "Mon", small: "monday"),
  tuesday(name: "Tuesday", short: "Tue", small: "tuesday"),
  wednesday(name: "Wednesday", short: "Wed", small: "wednesday"),
  thursday(name: "Thursday", short: "Thu", small: "thursday"),
  friday(name: "Friday", short: "Fri", small: "friday"),
  saturday(name: "Saturday", short: "Sat", small: "saturday");

  final String name;
  final String short;
  final String small;
  const Day({required this.name, required this.short, required this.small});

  static Day getDayFromDateTimeInt(int dayNumber) {
    return {
      DateTime.sunday: sunday,
      DateTime.monday: monday,
      DateTime.tuesday: tuesday,
      DateTime.wednesday: wednesday,
      DateTime.thursday: thursday,
      DateTime.friday: friday,
      DateTime.saturday: saturday,
    }[dayNumber]!;
  }
}

@Freezed(genericArgumentFactories: true)
sealed class Days<T> with _$Days<T> {
  const Days._();

  factory Days({
    required T monday,
    required T tuesday,
    required T wednesday,
    required T thursday,
    required T friday,
    required T saturday,
    required T sunday,
  }) = _Days<T>;

  factory Days.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$DaysFromJson(json, fromJsonT);

  // This is done to fix a bug with json serializer
  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => throw UnimplementedError;

  List<(Day, T)> get asList => [
        (Day.monday, monday),
        (Day.tuesday, tuesday),
        (Day.wednesday, wednesday),
        (Day.thursday, thursday),
        (Day.friday, friday),
        (Day.saturday, saturday),
        (Day.sunday, sunday),
      ];

  T getDayFromDateInt(int date) {
    switch (date) {
      case DateTime.monday:
        return monday;
      case DateTime.tuesday:
        return tuesday;
      case DateTime.wednesday:
        return wednesday;
      case DateTime.thursday:
        return thursday;
      case DateTime.friday:
        return friday;
      case DateTime.saturday:
        return saturday;
      case DateTime.sunday:
        return sunday;
      default:
        throw Exception("Invalid day");
    }
  }
}
