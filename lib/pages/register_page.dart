// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:reg_user_app/serivices/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserService service = UserService();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register User"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Email", emailController, type: TextInputType.emailAddress, validator: _validateEmail),
              _buildTextField("Phone", phoneController, type: TextInputType.phone, validator: _validatePhone),
              _buildTextField("Address", addressController, maxLines: 2),
              _buildPasswordField(),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    color: Colors.black
                  ),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: Colors.black),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
  if (_formKey.currentState!.validate()) {
   await  service.saveUser(
      nameController.text,
      phoneController.text,
      emailController.text,
      addressController.text,
      passwordController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration Successful')),
    );

    Navigator.pop(context, true);
    print('Returned true from register page');  // ✅ return true to trigger refresh
 // Go back to list pages

                    nameController.clear();
                    emailController.clear();
                    phoneController.clear();
                    addressController.clear();
                    passwordController.clear();
                  }
                },
                child: const Text("Register", style: TextStyle(fontSize: 25,
                color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType type = TextInputType.text, String? Function(String?)? validator, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          decoration:  InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter $label",
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                return null;
              },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password"),
        const SizedBox(height: 5),
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Enter Password",
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
