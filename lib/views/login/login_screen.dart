import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:masterreads/Service/authentication.dart';
import 'package:masterreads/main.dart';
import 'package:masterreads/routes/routes.dart';
import 'package:masterreads/views/UserRoleRouting/RoleRouting.dart';
import 'package:masterreads/views/login/login_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masterreads/views/user/profilePage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  String email = '', password = '';
  final auth = FirebaseAuth.instance;
  final AuthService _auth = AuthService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              const Text(
                'Log in',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text(
                        "Remember me",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      contentPadding: EdgeInsets.zero,
                      value: rememberValue,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (newValue) {
                        setState(() {
                          rememberValue = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AuthService>()
                              .SignInWithEmail(email, password);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthenticationWrapper()));

                        }

                        // if (_formKey.currentState!.validate()) {
                        //   dynamic result =
                        //       await _auth.SignInWithEmail(email, password);
                        //   if (result == null) {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                                // return AlertDialog(
                                //   title: Text('Login Error'),
                                //   content: const Text(
                                //       'The user credentials entered are not correct. \nEnsure you enter the correct details'),
                                //   actions: <Widget>[
                                //     ElevatedButton(
                                //       child: const Text('Ok'),
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 const LoginPage(
                                //                     title: "Log in"),
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //   ],
                                // );
                        //       },
                        //     );
                        //   } else {
                        //     SchedulerBinding.instance.addPostFrameCallback((_) {
                        //       Navigator.of(context)
                        //           .pushNamed(AppRoutes.routeProfilePage);
                        //     });
                        //   }
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.routeForgotPassword);
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    const LoginOption(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not registered yet?',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.routeSignUp);
                          },
                          child: const Text(
                            'Create an account',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
