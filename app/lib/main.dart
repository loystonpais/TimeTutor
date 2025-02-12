import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetutor/globals.dart';
import 'package:timetutor/pages/auth.dart';
import 'package:timetutor/pages/home.dart';
import 'package:timetutor/pages/profile_creator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://vjqchnayhjfnuqjwyvcw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqcWNobmF5aGpmbnVxand5dmN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2MTMwMzgsImV4cCI6MjA1MzE4OTAzOH0.WU1M4XpeyfRDplKsFwBX9j-ot7Ea1Y03DP-2dfhUzWU',
      authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce));

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTutor',
      theme: FlexThemeData.dark(scheme: FlexScheme.amber),
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
                  .from("users")
                  .select()
                  .eq("id", session.user.id)
                  .single(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check if profile exists
                if (snapshot.hasData && snapshot.data != null) {
                  return HomePage();
                } else {
                  return ProfileCreatorPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}
