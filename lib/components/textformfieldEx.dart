import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RoundedText extends StatefulWidget {
  const RoundedText({
    super.key,
    this.enabled = true,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.labelText,
    this.onChanged,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength = 15,
  });

  final bool enabled;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int maxLength;

  @override
  State<RoundedText> createState() => _RoundedTextState();
}

class _RoundedTextState extends State<RoundedText> {
  late bool obscureText;
  final List<TextInputFormatter> inputFormatters = [];

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
    if (widget.inputFormatters != null) {
      inputFormatters.addAll(widget.inputFormatters!);
    }
    inputFormatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        obscureText: obscureText,
        enabled: widget.enabled,
        controller: widget.controller,
        // cursorColor: borderColor,
        // style: black15SemiBoldTextStyle,
        validator: widget.validator,
        inputFormatters: inputFormatters,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: widget.obscureText ? _passwordIcon() : widget.suffixIcon,
        ),
    );
  }

  _passwordIcon() => InkWell(
    onTap: () => setState(() => obscureText = !obscureText),
    child: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
  );
}
