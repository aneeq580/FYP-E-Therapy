import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final Color? borderColor;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    required this.controller,
    this.isPassword = false,
    this.borderColor,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        widget.borderColor ?? const Color(0xFFB0C4CC); // default light border

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: effectiveBorderColor),
        prefixIcon: widget.icon != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: FaIcon(
                  widget.icon,
                  color: effectiveBorderColor,
                  size: 18,
                ),
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: effectiveBorderColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: effectiveBorderColor, width: 2.0),
        ),
      ),
    );
  }
}
