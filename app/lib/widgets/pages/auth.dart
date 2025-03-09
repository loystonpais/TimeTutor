import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:timetutor/globals.dart' as globals;
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
      child: Column(
        children: [
          /*SvgPicture.asset("assets/main_logo.svg",
              width: 200,
              height: 100,
              semanticsLabel: "TimeTutor Logo",
              fit: BoxFit.fitWidth,
              colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor, BlendMode.srcIn))*/
          Image.asset("assets/main_logo.png"),
          SupaEmailAuth(
            onSignInComplete: (response) async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Signed in as ${response.user!.email}')));
              //globals.authUser = response.user!;
            },
            onSignUpComplete: (response) {},
          ),
        ],
      ),
    ));
  }
}
