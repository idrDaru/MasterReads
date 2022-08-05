import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:masterreads/Service/authentication.dart';
import 'package:masterreads/main.dart';
import 'package:masterreads/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  final auth = FirebaseAuth.instance;
  final firstNameControl = TextEditingController();
  final secondNameControl = TextEditingController();
  // final roleControl= B
  final AuthService _auth = AuthService(FirebaseAuth.instance);
  String email = '';
  String password = '';
  String role= 'buyer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                'Sign up',
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

                  Container(
                  width:200.0,
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                     Expanded(

                         child:
                         ToggleSwitch(

                           minWidth: 99.0,
                           minHeight: 50.0,
                           initialLabelIndex: 0,
                           cornerRadius: 5.0,
                           activeFgColor: Colors.white,
                           inactiveBgColor: Colors.grey,
                           inactiveFgColor: Colors.white,
                           activeBgColor: [Colors.purple],
                           totalSwitches: 2,
                           labels: const ['Buyer', 'Seller'],
                          
                           activeBgColors: [[Colors.purple.shade600, Colors.black26], [Colors.purple, Colors.orange]],
                           animate: true, // with just animate set to true, default curve = Curves.easeIn
                           curve: Curves.bounceInOut, // animate must be set to true when using custom curve
                           onToggle: (index) {

                             if(index==0)
                               {
                                 role='buyer';
                               }

                             else
                               {
                                 role='seller';
                               }

                              print (role);

                             print('switched to: $index');
                           },
                         ),
                       ),

                     ],
                    ),
                  ),
                    Row(
                      children: [

                        Expanded(
                          child: TextFormField(
                            controller: firstNameControl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'First name',
                              hintStyle: TextStyle(fontFamily: 'Poppins'),
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: secondNameControl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              hintStyle: TextStyle(fontFamily: 'Poppins'),
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value.toString().trim();
                      },
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
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Please enter a strong password with minimum 8 characters';
                        } else
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth.RegisterWithEmail(email,
                              password, firstNameControl, secondNameControl, role);
                          if (result == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Oops'),
                                  content: const Text(
                                      'This user Already Exists, kindly log into your account.'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        AuthenticationWrapper();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.routeProfilePage);
                            });
                          }
                        }

                        // else
                        //   {
                        //     dynamic result= await _auth.RegisterWithEmail(email, password);
                        //   }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already registered?',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthenticationWrapper(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
