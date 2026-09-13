import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Forces the on-screen keyboard closed and clears focus.
///
/// `FocusScope.of(context).unfocus()` alone isn't reliable around a
/// [showModalBottomSheet]: Android's IME can reconnect to a field that had
/// focus before the sheet was pushed once its route is popped, regardless
/// of Flutter's own focus state at push time. Calling this both before
/// showing such a sheet and again after it closes (in a `.then`) clears
/// both the framework's focus and the platform's IME connection.
void dismissKeyboard(BuildContext context) {
  FocusManager.instance.primaryFocus?.unfocus();
  SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
}
