import 'package:flutter/material.dart';

class CenteredPage extends StatefulWidget {
  final Widget child;
  final double boxWidth;
  final double margin;
  final double padding;
  const CenteredPage({
    super.key,
    required this.child,
    this.boxWidth = 500,
    this.margin = 20.0,
    this.padding = 0,
  });

  @override
  State<CenteredPage> createState() => _CenteredPageState();
}

class _CenteredPageState extends State<CenteredPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.margin),
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Center(
          child: SizedBox(
            width: widget.boxWidth,
            height: double.infinity,
            // Child is put here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(child: widget.child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
