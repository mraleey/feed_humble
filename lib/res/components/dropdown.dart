import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final Color? labelColor;
  final Color? dropdownColor;
  final Color? iconColor;
  final Color? dropdownBorderColor;

  const CustomDropDownMenu({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.labelColor,
    this.dropdownColor,
    this.iconColor,
    this.dropdownBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: CustomFontSize.large(context),
          color: labelColor ?? AppColor.lightBlue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: dropdownBorderColor ?? AppColor.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: dropdownBorderColor ?? AppColor.darkGrey),
        ),
        filled: true,
        fillColor: dropdownColor ?? Colors.white,
      ),
    );
  }
}
