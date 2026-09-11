import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      this.customKey,
      this.onPressed,
      required this.text,
      this.isRedText = false,
      this.loadingText = 'Loading...',
      this.isLoading = false});

  final void Function()? onPressed;
  final String text;
  final String loadingText;
  final bool isRedText;
  final bool isLoading;
  final Key? customKey;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final TextTheme textTheme = Theme.of(context).textTheme;
    return isLoading
        ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(loadingText, style: textTheme.bodyMedium),
        )
        : Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
              key: customKey,
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text,
                      style: textTheme.bodyMedium?.copyWith(
                          color: isRedText ? colorScheme.error : null)),
                ],
              )),
    );
  }
}
