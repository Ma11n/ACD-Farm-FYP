import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxtField extends StatefulWidget {
  TxtField({
    Key? key,
    required this.label,
    this.validator,
    required this.controller,
    required this.forPass,
    required this.keyboard,
    this.onchange,
    this.onlyCharaters,
    this.canEdit,
  }) : super(key: key);

  final String label;
  final String? Function(String?)? validator;
  final Function(String?)? onchange;

  final TextEditingController controller;
  bool? onlyCharaters = false;
  final bool forPass;
  final bool? canEdit;
  final TextInputType keyboard;

  @override
  State<TxtField> createState() => _TxtFieldState();
}

class _TxtFieldState extends State<TxtField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: (widget.canEdit == null) ? true : widget.canEdit,
      onChanged: widget.onchange,
      obscureText: widget.forPass ? !_passwordVisible : widget.forPass,
      validator: widget.validator,
      keyboardType: widget.keyboard,
      controller: widget.controller,
      inputFormatters: widget.onlyCharaters == true
          ? [
              FilteringTextInputFormatter.allow(
                RegExp("[a-zA-Z ]"),
              ),
            ]
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: primaryColor),

        fillColor: Colors.white,
        // labelStyle: TextStyle(color: slider1textColor),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          // borderSide: BorderSide(
          //   color: slider1textColor,
          // ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        suffixIcon: widget.forPass
            ? IconButton(
                color: primaryColor,
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
