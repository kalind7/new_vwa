import 'package:flutter/material.dart';

/// Removes focus from the active text field, closing the software keyboard.
void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

/// Wraps [child] so tapping empty scaffold areas dismisses the keyboard.
class DismissKeyboardOnTap extends StatelessWidget {
  const DismissKeyboardOnTap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: dismissKeyboard,
      child: child,
    );
  }
}
