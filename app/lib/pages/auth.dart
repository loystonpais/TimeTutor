import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/widgets/centered_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CenteredPage(
      child: SupaEmailAuth(
        onSignInComplete: (response) async {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signed in as ${response.user!.email}')));
        },
        onSignUpComplete: (response) {},
      ),
    ));
  }
}
