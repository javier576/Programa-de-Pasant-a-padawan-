import 'package:flutter/material.dart';

class Custominput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;

  const Custominput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    required this.keyBoardType,
    required this.validator,
  });
  @override
  State<Custominput> createState() => _CustomImputState();
}

class _CustomImputState extends State<Custominput> {
  bool _isInvisible = false;

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.obscure;
    return TextFormField(
      controller: widget.controller,
      obscureText: isPasswordField && !_isInvisible,
      keyboardType: widget.keyBoardType,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: isPasswordField
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isInvisible = !_isInvisible;
                  });
                },
                icon: Icon(
                  _isInvisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[700],
                ),
              )
            : null,
      ),
    );
  }
}
