import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final Icon? prefixIcon;
  final bool autofocus;
  final Color? fillColor;

  const CustomSearchBar({
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search location',
    this.prefixIcon,
    this.autofocus = false,
    this.fillColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : Colors.grey[900],
        ),
        cursorColor: theme.primaryColor,
        cursorWidth: 1.5,
        cursorHeight: 20,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: prefixIcon ?? Icon(
            Icons.search_rounded,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 24,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 56,
            minHeight: 24,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 20,
            ),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
            splashRadius: 20,
          )
              : null,
          filled: true,
          fillColor: fillColor ?? (isDark ? Colors.grey[900] : Colors.white),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.primaryColor.withOpacity(0.4),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
