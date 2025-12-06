import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class SampleFormPage extends StatefulWidget {
  const SampleFormPage({super.key});

  @override
  State<SampleFormPage> createState() => _SampleFormPageState();
}

class _SampleFormPageState extends State<SampleFormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final genderCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Custom Form UI")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              CustomTextField(
                label: "Name*",
                controller: nameCtrl,
                validator: (val) =>
                val == null || val.isEmpty ? "Name is required" : null,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Email Address*",
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Email is required";
                  if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(val)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Location*",
                controller: locationCtrl,
                validator: (val) =>
                val == null || val.isEmpty ? "Location required" : null,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Age*",
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Age required";
                  if (int.tryParse(val) == null) return "Enter a valid number";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Gender*",
                controller: genderCtrl,
                validator: (val) =>
                val == null || val.isEmpty ? "Gender required" : null,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All fields valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Form Submitted")),
                    );
                  }
                },
                child: const Text("Submit"),
              ),

              SizedBox(height: 55,),

              CustomButton(
                text: "Log In",
                onPressed: () {
                  print("Login pressed");
                },
              )

            ],
          ),
        ),
      ),



    );
  }



}
