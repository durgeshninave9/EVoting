import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/auth_handler.dart';
import 'package:online_voting_system/screens/authentication.dart';
import 'package:online_voting_system/screens/home_screen.dart';
import 'package:online_voting_system/widget/input_data.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var pswdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                      // child: Image(),
                      ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text('SIGN IN',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InputData(
                    controller: emailController,
                    hint: 'Enter your email',
                    icon: Icons.email_rounded,
                    type: TextInputType.emailAddress,
                    obscure: false,
                    label: '',
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!value.contains('@')) {
                        return "Enter Valid Email ID";
                      } else {
                        return null;
                      }
                    }),
                InputData(
                  controller: pswdController,
                  hint: 'Enter your password',
                  icon: Icons.lock_rounded,
                  type: TextInputType.visiblePassword,
                  obscure: true,
                  label: '',
                  valid: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#_\$&*~]).{8,}$');
                    var nvalue = value ?? "";
                    if (nvalue.isEmpty) {
                      return ("Password is required");
                    } else if (nvalue.length < 7) {
                      return ("Password Must be more than 6 characters");
                    } else if (!regex.hasMatch(nvalue)) {
                      return ("Password should contain upper,lower,digit and Special character ");
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.find<AuthenticateHandler>().signInUsers(
                            emailController.text.toString().trim(),
                            pswdController.text.toString().trim());
                      },
                      label: const Text('SIGN IN'),
                      icon: const Icon(Icons.verified_user),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account ?",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authentication()));
                        },
                        child: Text(
                          " Register",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
