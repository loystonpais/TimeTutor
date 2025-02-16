import 'package:json_annotation/json_annotation.dart';

part 'classes.g.dart';

@JsonSerializable()
class Timing {
  final DateTime startTime;
  final DateTime endTime;

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);

  Map<String, dynamic> toJson() => _$TimingToJson(this);

  Timing({required this.startTime, required this.endTime});
}

@JsonSerializable()
class Subject {
  final String name;

  Subject({required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

class Period {
  final Subject subject;
  final Timing timing;

  Period({required this.subject, required this.timing});
}

abstract class TimeTable {}

@JsonSerializable(explicitToJson: true)
class StandardTimeTable extends TimeTable {
  final List<Timing> timings;
  final Days<List<Subject>> days;

  StandardTimeTable({required this.timings, required this.days});

  factory StandardTimeTable.fromJson(Map<String, dynamic> json) =>
      _$StandardTimeTableFromJson(json);

  Map<String, dynamic> toJson() => _$StandardTimeTableToJson(this);
}

enum Day {
  sunday(name: "Sunday"),
  monday(name: "Monday"),
  tuesday(name: "Tuesday"),
  wednesday(name: "Wednesday"),
  thursday(name: "Thursday"),
  friday(name: "Friday"),
  saturday(name: "Saturday");

  final String name;
  const Day({required this.name});
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
}
