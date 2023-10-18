import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnx/LoginPage.dart';

class PasswordReset extends StatefulWidget{
  const PasswordReset({super.key});
  @override
  State<PasswordReset> createState() => _PasswordResetState();
}
class _PasswordResetState extends State<PasswordReset>{
  final _email=TextEditingController();
  final _formkey=GlobalKey<FormState>();

  Future<void> resetPassword() async {
    final FirebaseAuth user = await FirebaseAuth.instance;
    try {
      user.sendPasswordResetEmail(
        email: _email.text,
      ).then((val){
        showCustomSnackBar('Check your email!', Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));
      }).onError((error, stackTrace){
        showCustomSnackBar('try again!', Colors.purple);
      });
    }
    catch (e) {
      showCustomSnackBar('Email not sent, try again!', Colors.purple);
    }
  }

  void showCustomSnackBar(String string, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Container(
          child: Text(
            string,
            style: TextStyle(
              color: color == Colors.red ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: Center(
        child: Card(
          elevation: 15,
          shadowColor: Colors.grey,
          child: Container(
            width: wi*0.85,
            height: hi*0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      icon: Icon(CupertinoIcons.mail_solid),
                    ),
                    validator: (val)=>val!.isEmpty?"Enter Valid Email":null,
                  ),
                  ElevatedButton(
                      onPressed: (){
                        if (_formkey.currentState!.validate()){
                          resetPassword();
                        }
                      },
                      child: Text("Reset Password"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}