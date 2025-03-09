import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'classes.g.dart';

@JsonSerializable()
class Timing {
  final DateTime startTime;
  final DateTime endTime;

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);

  Map<String, dynamic> toJson() => _$TimingToJson(this);

  Timing({required this.startTime, required this.endTime});

  @override
  String toString() {
    String formatTimeOfDay(DateTime dt) {
      final now = DateTime.now();
      final newDt = DateTime(now.year, now.month, now.day, dt.hour, dt.minute);
      final format = DateFormat.jm();
      return format.format(newDt);
    }

    return "${formatTimeOfDay(startTime)}-${formatTimeOfDay(endTime)}";
  }
}

@JsonSerializable()
class Subject {
  final String name;

  Subject({required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

@JsonSerializable()
class Period {
  final Subject subject;
  final Timing timing;

  Period({required this.subject, required this.timing});

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

abstract class TimeTable {}

@JsonSerializable(explicitToJson: true)
class StandardTimetable extends TimeTable {
  final List<Timing> timings;
  final Days<List<Subject>> days;

  Days<List<Period>> get dayWithPeriods {
    return Days<List<Period>>(
      sunday: _zipPeriods(days.sunday),
      monday: _zipPeriods(days.monday),
      tuesday: _zipPeriods(days.tuesday),
      wednesday: _zipPeriods(days.wednesday),
      thursday: _zipPeriods(days.thursday),
      friday: _zipPeriods(days.friday),
      saturday: _zipPeriods(days.saturday),
    );
  }

  List<Period> _zipPeriods(List<Subject> subjects) {
    final length =
        subjects.length < timings.length ? subjects.length : timings.length;
    return List.generate(
      length,
      (index) => Period(
        subject: subjects[index],
        timing: timings[index], // Guaranteed to be within bounds
      ),
    );
  }

  StandardTimetable({required this.days, required this.timings});

  factory StandardTimetable.fromJson(Map<String, dynamic> json) =>
      _$StandardTimetableFromJson(json);

  Map<String, dynamic> toJson() => _$StandardTimetableToJson(this);

  /*List<Period> getPeriodsOf(int n) {
    final day = days.getDayFromDateInt(n);
    day.map((e) {});
  }*/
}

enum Day {
  sunday(name: "Sunday", short: "Sun"),
  monday(name: "Monday", short: "Mon"),
  tuesday(name: "Tuesday", short: "Tue"),
  wednesday(name: "Wednesday", short: "Wed"),
  thursday(name: "Thursday", short: "Thu"),
  friday(name: "Friday", short: "Fri"),
  saturday(name: "Saturday", short: "Sat");

  final String name;
  final String short;
  const Day({required this.name, required this.short});

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

@JsonSerializable(genericArgumentFactories: true)
class Days<T> {
  final T monday;
  final T tuesday;
  final T wednesday;
  final T thursday;
  final T friday;
  final T saturday;
  final T sunday;

  Days(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday});

  factory Days.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$DaysFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$DaysToJson(this, toJsonT);

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
