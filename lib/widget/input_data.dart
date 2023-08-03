import 'package:flutter/material.dart';

class InputData extends StatefulWidget {
  final String hint;
  final IconData icon;
  final String label;
  final TextInputType type;
  final TextEditingController controller;
  final bool obscure;
  final dynamic valid;
  final dynamic change;
  const InputData(
      {required this.hint,
      required this.icon,
      required this.label,
      required this.type,
      required this.controller,
      required this.obscure,
      required this.valid,
      this.change,
      super.key});

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: TextFormField(
          obscureText: widget.obscure,
          controller: widget.controller,
          keyboardType: widget.type,
          validator: widget.valid,
          onChanged: widget.change,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(fontSize: 22.0),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 16.0),
            fillColor: Colors.white,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            prefixIcon: Icon(
              widget.icon,
              color: Colors.blueGrey,
            ),
            hintText: widget.hint,
          ),
        ));
  }
}
