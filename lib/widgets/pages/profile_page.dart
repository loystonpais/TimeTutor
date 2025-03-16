import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/models/supabase.dart';
import 'package:timetutor/widgets/centered_page.dart';
import 'package:timetutor/widgets/info_bar.dart';
import 'package:timetutor/widgets/loading.dart';
import 'package:timetutor/widgets/pages/institution_class_selector.dart';
import 'package:timetutor/widgets/pages/profile_editor.dart';
import 'package:timetutor/widgets/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<
      ({
        Map<String, dynamic> profile,
        Map<String, dynamic> class_,
        Map<String, dynamic> institution
      })> _fetchData() async {
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

    final class_ =
        await client.from("classes").select().eq("id", joinedClass).single();

    Map<String, dynamic> institution = await client
        .from("institutions")
        .select()
        .eq("id", class_["institution"])
        .limit(1)
        .single();

    return (profile: profile, class_: class_, institution: institution);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final (:profile, :class_, :institution) = snapshot.data!;

          return SingleChildScrollView(
            //physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Avatar and Name
                  Center(
                    child: RandomAvatar(
                      profile["avatar_string"],
                      trBackground: appSettings.monoColor,
                      theme: (appSettings.monoColor)
                          ? SvgTheme(
                              currentColor: Theme.of(context).primaryColor)
                          : SvgTheme(),
                      colorFilter: appSettings.monoColor
                          ? ColorFilter.mode(
                              Theme.of(context).primaryColorLight,
                              BlendMode.modulate)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    profile["name"],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  InfoBar(
                    color: appSettings.monoColor ? null : Colors.redAccent,
                    onTap: () {},
                    child: Column(children: [
                      Center(
                          child: Row(
                        children: [
                          Text(
                              "Joined ${class_['name']} of ${institution['name']}"),
                          SizedBox(width: 10),
                          if (institution["verified"]) Icon(Icons.verified)
                        ],
                      )),
                    ]),
                  ),
                  InfoBar(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileEditorPage()),
                      );
                      setState(() {});
                    },
                    color: appSettings.monoColor ? null : Colors.deepOrange,
                    child: Row(
                      children: [
                        Icon(Icons.mode_edit),
                        SizedBox(width: 12),
                        Text('Edit Profile'),
                      ],
                    ),
                  ),
                  InfoBar(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InstituionClassSelectorPage()),
                      );
                      setState(() {});
                    },
                    color: appSettings.monoColor ? null : Colors.yellow,
                    child: Row(
                      children: [
                        Icon(Icons.class_outlined),
                        SizedBox(width: 12),
                        Text('Switch class'),
                      ],
                    ),
                  ),
                  InfoBar(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                      setState(() {});
                    },
                    color: appSettings.monoColor ? null : Colors.cyanAccent,
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 12),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  InfoBar(
                    onTap: () async {
                      await client.auth.signOut();
                    },
                    color: appSettings.monoColor ? null : Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 12),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
