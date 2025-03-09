import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/classes/supabase.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/info_bar.dart';
import 'package:timetutor/widgets/loading.dart';
import 'package:timetutor/widgets/timetable_period_countdown.dart';
import 'package:timetutor/widgets/timetable_carousel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*Widget carousel = TimetableCarousel(
    //timetable: timetable,
    editable: true,
    onEdit: (editedJson) async {
      await Supabase.instance.client
          .from("users")
          .update({"timetable": editedJson}).eq(
              "id", Supabase.instance.client.auth.currentUser!.id);
    },
  );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return _withDraggableHome();
      }),
    );
  }

  Future<({Map<String, dynamic> profile, Map<String, dynamic> class_})>
      _fetchData() async {
    final profile = await client
        .from("profiles")
        .select()
        .eq("id", client.auth.currentUser!.id)
        .limit(1)
        .maybeSingle();

    if (profile == null) {
      throw Exception("Your profile doesn't exist!");
    }

    final String joinedClass = profile['joined_class'];

    final class_ = await client
        .from("classes")
        .select()
        .eq(
          "id",
          joinedClass,
        )
        .maybeSingle();

    if (class_ == null) {
      throw Exception("The class does not exist");
    }

    return (profile: profile, class_: class_);
  }

  Widget _withDraggableHome() {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return Loading();
          }

          final (:profile, :class_) = snapshot.data!;

          Widget expandedBody;
          Widget headerWidget;

          if (class_["timetable"] != null) {
            final StandardTimetable timetable =
                StandardTimetable.fromJson(class_["timetable"]);

            expandedBody = Center(
              child: FractionallySizedBox(
                  //widthFactor: 0.9,
                  heightFactor: 0.9,
                  child: TimetableCarouselSlider(
                      editable: true, timetable: timetable, onEdit: (json) {})),
            );

            headerWidget =
                Center(child: TimetablePeriodCountdown(timetable: timetable));
          } else {
            expandedBody =
                Center(child: Text("The timetable has not been set!"));
            headerWidget =
                Center(child: Text("The timetable has not been set!"));
          }

          return DraggableHome(
            headerExpandedHeight: 0.35,
            body: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoBar(
                      infoText: "Information 1",
                      color: Colors.lightBlue,
                      onTap: () {
                        // Handle tap action for Information 1
                      },
                    ),
                    InfoBar(
                      color: Colors.redAccent,
                      infoText: "Information 2",
                      onTap: () {
                        // Handle tap action for Information 2
                      },
                    ),
                    InfoBar(
                      color: Colors.lightGreen,
                      infoText: "Information 3",
                      onTap: () {
                        // Handle tap action for Information 3
                      },
                    ),
                  ],
                ),
              )
            ],
            headerWidget: headerWidget,
            title: Text("TimeTutor"),
            expandedBody: expandedBody,
            fullyStretchable: true,
            headerBottomBar: null,
          );
        });
  }
}
