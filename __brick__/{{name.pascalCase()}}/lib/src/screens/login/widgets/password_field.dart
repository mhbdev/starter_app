import 'package:apex_api/apex_api.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final List<String>? autoFillHints;
  final bool readOnly;
  final ValueChanged<String>? onSubmitted;

  const PasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.autoFillHints,
    this.readOnly = false, this.onSubmitted,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with MountedStateMixin {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscure,
      readOnly: widget.readOnly,
      controller: widget.controller,
      autofillHints: widget.autoFillHints,
      onFieldSubmitted: widget.onSubmitted,
      maxLength: 32,
      keyboardType: TextInputType.text,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              mountedSetState(() {
                _obscure = !_obscure;
              });
            },
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
          ),
        ),
        prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.lock_outline)),
      ),
    );
  }
}
