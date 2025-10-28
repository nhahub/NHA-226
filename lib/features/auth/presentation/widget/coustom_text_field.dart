import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';

// ignore: must_be_immutable
class CoustomTextFormField extends StatefulWidget {
  CoustomTextFormField({
    super.key,
    required this.text,
    this.obscureText = false,
    required this.validator,
    required this.controller,
    this.icon,
  });

  final TextEditingController controller;
  final String text;
  final bool obscureText;
  final FormFieldValidator validator;
  Icon? icon;

  @override
  State<CoustomTextFormField> createState() => _CoustomTextFormFieldState();
}

class _CoustomTextFormFieldState extends State<CoustomTextFormField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText ? _isObscure : false,
        validator: widget.validator,
        style: TextStyle(color: AppColor().black),
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
              ? IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : widget.icon,
          errorStyle: TextStyle(height: 0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          hintText: widget.text,
          hintStyle: TextStyle(color: Color(0xff808080)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
