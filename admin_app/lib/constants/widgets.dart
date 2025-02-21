import 'package:flutter/material.dart';

Widget phoneNumberTextField({
  required TextEditingController
      phoneController, // Controller for the TextField
  required List<DropdownMenuItem<String>> countryItems, // Dropdown items
  required Function(String?)
      onCountryChanged, // Callback for dropdown value change
  void Function(String)? onTextfieldChanged, // Callback for text change
  String? initialCountryCode = 'jo', // Initial value for the dropdown
  String? hintText, // Placeholder text for the TextField
  double dropdownFlex = 7, // Flex for the dropdown
  double textFieldFlex = 19, // Flex for the text field
  double spaceFlex = 1, // Flex for the space between the components
  double height = 50, // Common height for all components
  double borderRadius = 12, // Border radius for dropdown and text field
  EdgeInsetsGeometry dropdownPadding =
      const EdgeInsets.symmetric(horizontal: 8),
  EdgeInsetsGeometry textFieldPadding =
      const EdgeInsets.symmetric(horizontal: 16),
  TextStyle? textFieldStyle, // Custom text style for the TextField
}) {
  return Row(
    children: [
      // Expanded for the DropdownButtonFormField
      Expanded(
        flex: dropdownFlex.toInt(),
        child: SizedBox(
          height: height,
          child: DropdownButtonFormField(
            isExpanded: true,
            value: initialCountryCode,
            items: countryItems,
            onChanged: onCountryChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              contentPadding: dropdownPadding,
            ),
          ),
        ),
      ),
      Expanded(
        flex: spaceFlex.toInt(),
        child: const SizedBox(),
      ),
      Expanded(
        flex: textFieldFlex.toInt(),
        child: SizedBox(
          height: height,
          child: TextField(
            onChanged: onTextfieldChanged,
            keyboardType: TextInputType.phone,
            controller: phoneController,
            style: textFieldStyle,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              contentPadding: textFieldPadding,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget customTextField({
  TextEditingController? controller,
  String? label, // Label text above the field
  String? hintText, // Placeholder inside the field
  TextInputType keyboardType = TextInputType.text, // Type of keyboard
  bool obscureText = false, // Whether to hide the text (e.g., for passwords)
  IconData? prefixIcon, // Icon displayed at the start of the field
  IconData? suffixIcon, // Icon displayed at the end of the field
  VoidCallback? onSuffixIconTap, // Action for tapping the suffix icon
  String? Function(String?)? validator, // Validation function
  void Function(String)? onChanged, // Callback for text change
  void Function()? onEditingComplete, // Action on editing completion
  void Function(String)? onSubmitted, // Action on submit
  double borderRadius = 37.5, // Rounded corners for the field
  Color? fillColor, // Background color of the field
  bool filled = false, // Whether the field has a background
  TextStyle? textStyle, // Style for the text inside the field
  TextStyle? hintStyle, // Style for the hint text
  TextStyle? labelStyle, // Style for the label text
  Color borderColor = Colors.grey, // Color for the field border
  double borderWidth = 1.0, // Width of the field border
  EdgeInsetsGeometry? contentPadding, // Padding inside the field
  int? maxLines = 1, // Maximum number of lines for the field
  int? minLines, // Minimum number of lines for the field
  bool expands = false, // Whether the field can expand vertically
  int? maxLength, // Maximum number of characters
  bool readOnly = false, // Whether the field is read-only
  bool enabled = true, // Whether the field is enabled
  TextInputAction? textInputAction, // Action for the keyboard button
  FocusNode? focusNode, // Focus node for the field
  double? height, // Height of the field
  bool enableSuggestions = false, // Whether to enable suggestions
  bool autocorrect = false, // Whether to enable autocorrect
}) {
  return height != null
      ? SizedBox(
          height: height,
          child: TextField(
            enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            maxLength: maxLength,
            readOnly: readOnly,
            enabled: enabled,
            textInputAction: textInputAction,
            focusNode: focusNode,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            style: textStyle,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: labelStyle,
              hintText: hintText,
              hintStyle: hintStyle,
              filled: filled,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              contentPadding: contentPadding,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(suffixIcon),
                    )
                  : null,
            ),
          ),
        )
      : TextField(
          controller: controller,
          enableSuggestions: enableSuggestions,
          autocorrect: autocorrect,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          readOnly: readOnly,
          enabled: enabled,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          style: textStyle,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            hintText: hintText,
            hintStyle: hintStyle,
            filled: filled,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            contentPadding: contentPadding,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixIconTap,
                    child: Icon(suffixIcon),
                  )
                : null,
          ),
        );
}
