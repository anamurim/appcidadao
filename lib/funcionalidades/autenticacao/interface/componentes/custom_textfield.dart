import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class TechTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;

  const TechTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppCores.neonBlue),
        filled: true,
        fillColor: AppCores.lightGray.withValues(alpha: 0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppCores.electricBlue.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppCores.neonBlue),
        ),
      ),
    );
  }
}
