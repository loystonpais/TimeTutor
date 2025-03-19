import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/widgets/info_bar.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/extensions/extensions.dart';

import 'package:intl/intl.dart';

class TimetableEditorPage extends StatefulWidget {
  final Timetable initialTimetable;
  final String classId;

  const TimetableEditorPage({
    super.key,
    required this.initialTimetable,
    required this.classId,
  });

  @override
  State<TimetableEditorPage> createState() => _TimetetableEditorPageState();
}

class _TimetetableEditorPageState extends State<TimetableEditorPage> {
  late Timetable editedTimetable;
  late Days<List<Subject>> editedDays;
  late List<Timing> editedTimings;
  late Day selectedDay;

  @override
  void initState() {
    super.initState();
    editedTimetable = Timetable.fromJson(widget.initialTimetable.toJson());
    editedDays = editedTimetable.days;
    editedTimings = List.from(editedTimetable.timings);
    selectedDay = Day.monday;
  }

  Future<void> _saveTimetable() async {
    final updatedTimetable = Timetable(
      days: editedDays,
      timings: editedTimings,
    );

    await client.from("classes").update({"timetable": updatedTimetable.toJson()}).eq("id", widget.classId);

    Navigator.pop(context, updatedTimetable);
  }

  void _addTimeSlot() {
    setState(() {
      final lastEnd = editedTimings.isNotEmpty ? editedTimings.last.endTime : DateTime(0, 0, 0, 8, 30);

      editedTimings.add(Timing(
        startTime: lastEnd,
        endTime: lastEnd.add(Duration(minutes: 45)),
      ));

      // Add empty subject to all days
      editedDays = Days(
        monday: [...editedDays.monday, Subject(name: '')],
        tuesday: [...editedDays.tuesday, Subject(name: '')],
        wednesday: [...editedDays.wednesday, Subject(name: '')],
        thursday: [...editedDays.thursday, Subject(name: '')],
        friday: [...editedDays.friday, Subject(name: '')],
        saturday: [...editedDays.saturday, Subject(name: '')],
        sunday: [...editedDays.sunday, Subject(name: '')],
      );
    });
  }

  void _updateSubject(int index, String name) {
    setState(() {
      final daySubjects = _getCurrentDaySubjects();
      daySubjects[index] = Subject(name: name);
      _updateDaySubjects(daySubjects);
    });
  }

  void _updateTiming(int index, Timing newTiming) {
    setState(() {
      editedTimings[index] = newTiming;
    });
  }

  List<Subject> _getCurrentDaySubjects() {
    switch (selectedDay) {
      case Day.monday:
        return editedDays.monday;
      case Day.tuesday:
        return editedDays.tuesday;
      case Day.wednesday:
        return editedDays.wednesday;
      case Day.thursday:
        return editedDays.thursday;
      case Day.friday:
        return editedDays.friday;
      case Day.saturday:
        return editedDays.saturday;
      case Day.sunday:
        return editedDays.sunday;
    }
  }

  void _updateDaySubjects(List<Subject> subjects) {
    switch (selectedDay) {
      case Day.monday:
        editedDays = editedDays.copyWith(monday: subjects);
        break;
      case Day.tuesday:
        editedDays = editedDays.copyWith(tuesday: subjects);
        break;
      case Day.wednesday:
        editedDays = editedDays.copyWith(wednesday: subjects);
        break;
      case Day.thursday:
        editedDays = editedDays.copyWith(thursday: subjects);
        break;
      case Day.friday:
        editedDays = editedDays.copyWith(friday: subjects);
        break;
      case Day.saturday:
        editedDays = editedDays.copyWith(saturday: subjects);
        break;
      case Day.sunday:
        editedDays = editedDays.copyWith(sunday: subjects);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTimetable,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: ListView.builder(
              itemCount: editedTimings.length,
              itemBuilder: (context, index) => _buildTimeSlot(index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTimeSlot,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDaySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Day.values.map((day) {
          final isSelected = day == selectedDay;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              label: Text(day.name),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedDay = day),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSlot(int index) {
    final timing = editedTimings[index];
    final subject = _getCurrentDaySubjects()[index];
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: subject.name,
                    decoration: InputDecoration(labelText: 'Subject'),
                    onChanged: (value) => _updateSubject(index, value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _editTiming(index),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Start: ${timeFormat.format(timing.startTime)}'),
                Text('End: ${timeFormat.format(timing.endTime)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTiming(int index) async {
    final timing = editedTimings[index];
    final newTiming = await showDialog<Timing>(
      context: context,
      builder: (context) => TimingEditorDialog(initialTiming: timing),
    );

    if (newTiming != null) {
      _updateTiming(index, newTiming);
    }
  }
}

class TimingEditorDialog extends StatefulWidget {
  final Timing initialTiming;

  const TimingEditorDialog({super.key, required this.initialTiming});

  @override
  State<TimingEditorDialog> createState() => _TimingEditorDialogState();
}

class _TimingEditorDialogState extends State<TimingEditorDialog> {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialTiming.startTime;
    _endTime = widget.initialTiming.endTime;
  }

  Future<void> _selectTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );

    if (picked != null) {
      setState(() {
        final newTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          picked.hour,
          picked.minute,
        );

        if (isStart) {
          _startTime = newTime;
          if (_startTime.isAfter(_endTime)) {
            _endTime = _startTime.add(Duration(minutes: 45));
          }
        } else {
          _endTime = newTime;
          if (_endTime.isBefore(_startTime)) {
            _startTime = _endTime.subtract(Duration(minutes: 45));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return AlertDialog(
      title: const Text('Edit Time Slot'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Time'),
            trailing: Text(timeFormat.format(_startTime)),
            onTap: () => _selectTime(true),
          ),
          ListTile(
            title: const Text('End Time'),
            trailing: Text(timeFormat.format(_endTime)),
            onTap: () => _selectTime(false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              Timing(
                startTime: _startTime,
                endTime: _endTime,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
