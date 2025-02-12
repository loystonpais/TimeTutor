import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/timetable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from("users").select();
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: _future,
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return const Center(child: CircularProgressIndicator());
    //       }

    //       final users = snapshot.data!;
    //       return ListView.builder(
    //         itemBuilder: (context, index) {
    //           final user = users[index];
    //           return ListTile(title: Text(user["first_name"]));
    //         },
    //         itemCount: users.length,
    //       );
    //     });

    return Scaffold(
      body: CenteredPage(
          child: TimetableCarousel(
              timetable: StandardTimeTable.fromJson({
        "timings": [
          {
            "startTime": "-0001-11-30T09:00:00.000",
            "endTime": "-0001-11-30T09:45:00.000"
          }
        ],
        "days": {
          "monday": ["PHP", "AI", "J2EE"],
          "tuesday": [],
          "wednesday": [],
          "thursday": ["AI", "PHP", "J2EE"],
          "friday": [],
          "saturday": [],
          "sunday": [],
        }
      }))),
    );
  }
}
