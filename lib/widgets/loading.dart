import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingFour(
        color: Theme.of(context).primaryColor,
        size: 50.0,
      ),
    );
  }
}

class LoadingSmall extends StatelessWidget {
  const LoadingSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: Theme.of(context).primaryColor,
        size: 10,
      ),
    );
  }
}
