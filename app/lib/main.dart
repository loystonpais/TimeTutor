import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetutor/models/settings.dart';
import 'package:timetutor/widgets/loading.dart';
import 'package:timetutor/widgets/pages/auth.dart';
import 'package:timetutor/widgets/pages/home.dart';
import 'package:timetutor/widgets/pages/profile_editor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetutor/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await notificationsPlugin.initialize(initSettings);

  await Supabase.initialize(
      url: 'https://vjqchnayhjfnuqjwyvcw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqcWNobmF5aGpmbnVxand5dmN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2MTMwMzgsImV4cCI6MjA1MzE4OTAzOH0.WU1M4XpeyfRDplKsFwBX9j-ot7Ea1Y03DP-2dfhUzWU',
      authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce));

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    materialPageSetState = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTutor',
      theme: appSettings.darkTheme
          ? FlexThemeData.dark(
              scheme: FlexScheme.values.byName(appSettings.themeName),
              textTheme: GoogleFonts.oswaldTextTheme())
          : FlexThemeData.light(
              scheme: FlexScheme.values.byName(appSettings.themeName),
              textTheme: GoogleFonts.oswaldTextTheme()),
      home: const ImmediatePage(title: 'TimeTutor'),
    );
  }
}

class ImmediatePage extends StatefulWidget {
  const ImmediatePage({super.key, required this.title});

  final String title;

  @override
  State<ImmediatePage> createState() => _ImmediatePageState();
}

class _ImmediatePageState extends State<ImmediatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = snapshot.data?.session;
          if (session == null) {
            return AuthPage();
          } else {
            return FutureBuilder(
              // Single query instead of stream
              future: Supabase.instance.client
                  .from("profiles")
                  .select()
                  .eq("id", session.user.id)
                  .maybeSingle(),
              builder: (context, snapshot) {
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }

                // Check if profile exists
                if (snapshot.hasData) {
                  print("This worked");
                  final profile = snapshot.data!;

                  if (profile["app_settings"] != null) {
                    appSettings = AppSettings.fromJson(profile["app_settings"]);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      materialPageSetState();
                    });
                  }

                  return HomePage();
                } else {
                  print("wtf");
                  return ProfileEditorPage(
                    createIfDoesNotExist: true,
                    onProfileCreated: () {
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );*/
                      setState(() {});
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
