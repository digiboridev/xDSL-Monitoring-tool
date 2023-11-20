import 'dart:ui';
import 'package:flutter/material.dart';

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key, required this.child, required this.busy});

  final Widget child;
  final bool busy;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: [
        child,
        if (busy)
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.01),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
