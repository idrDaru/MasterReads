import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ResetForm extends StatefulWidget {
  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : "Please enter a valid email",
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Enter your email',
                hintStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
