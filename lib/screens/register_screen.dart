import 'package:flutter/material.dart';
import '../utils/validator.dart';
import '../utils/enums.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String pass = '';
  String confirm = '';
  Gender gender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Fill details to continue",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    _field("Full Name", Icons.person, (v) => name = v,
                        (v) => Validator.name(v!)),
                    _field("Email", Icons.email, (v) => email = v,
                        (v) => Validator.email(v!)),
                    _field("Password", Icons.lock, (v) => pass = v,
                        (v) => Validator.password(v!),
                        obscure: true),
                    _field("Confirm Password", Icons.lock_outline,
                        (v) => confirm = v, (v) => Validator.confirm(v!, pass),
                        obscure: true),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Gender>(
                      initialValue: gender,
                      decoration: _dec("Gender", Icons.transgender),
                      items: Gender.values.map((g) {
                        return DropdownMenuItem(value: g, child: Text(g.name));
                      }).toList(),
                      onChanged: (v) => gender = v!,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AuthController.register(UserModel(
                              name: name,
                              email: email,
                              password: pass,
                              gender: gender,
                            ));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          }
                        },
                        child: const Text("Create Account",
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    IconData icon,
    Function(String) onChange,
    String? Function(String?) validator, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        obscureText: obscure,
        onChanged: onChange,
        validator: validator,
        decoration: _dec(label, icon),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
