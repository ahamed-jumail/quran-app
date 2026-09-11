import 'package:flutter/material.dart';

import 'form_validation_helper.dart';

enum Validator{
  no_validator,
  empty_validator,
  password_validator
}

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {super.key, this.customKey, required this.controller, required this.labelText, this.validator = Validator.no_validator, });

  final TextEditingController controller;
  final String labelText;
  final Validator validator;
  final Key? customKey;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: customKey,
        controller: controller,
        validator: (String? val) {
          switch (validator){
            case Validator.no_validator:
              return FormValidationHelper().noValidator();
            case Validator.empty_validator:
              return FormValidationHelper.emptyValidator(controller.text);
            case Validator.password_validator:
              return FormValidationHelper.emptyValidator(controller.text);
          }
        },
        autovalidateMode: AutovalidateMode.always,
        style: textTheme.bodySmall,
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 2,
                color: colorScheme.primary,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 2,
                color: colorScheme.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 2,
                color: colorScheme.tertiary,
              ),
            ),
            border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: colorScheme.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hintText: 'Enter $labelText',
            hintStyle: textTheme.bodySmall,
            labelStyle: textTheme.bodySmall,
            labelText: labelText),
      ),
    );
  }
}
