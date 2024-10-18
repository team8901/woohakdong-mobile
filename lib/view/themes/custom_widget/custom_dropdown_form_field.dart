import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woohakdong/view/themes/theme_context.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String labelText;
  final List<Map<String, String>> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final void Function()? onTap;
  final double menuMaxHeight;

  const CustomDropdownFormField({
    super.key,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    this.onTap,
    this.menuMaxHeight = 384,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colorScheme.outline,
      ),
      style: context.textTheme.titleSmall,
      elevation: 0,
      menuMaxHeight: menuMaxHeight.h,
      dropdownColor: context.colorScheme.surfaceContainer,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: context.textTheme.titleSmall?.copyWith(
          color: context.colorScheme.outline,
        ),
        errorStyle: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.error,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.surfaceContainer),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['displayText']!, style: context.textTheme.titleSmall),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap,
    );
  }
}
