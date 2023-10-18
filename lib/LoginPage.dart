import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnx/HomePage.dart';
import 'package:learnx/PasswordResetPage.dart';
import 'package:learnx/SignupPage.dart';


class Login extends StatefulWidget{
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login>{
  final _email=TextEditingController();
  final _password=TextEditingController();
  final _formkey=GlobalKey<FormState>();
  bool _password_visibility=true;
  IconData _passicon=Icons.remove_red_eye_rounded;


  Future<void> registerUser() async {
    final FirebaseAuth user = await FirebaseAuth.instance;
    try {
      user.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ).then((val){
        showCustomSnackBar('Registration successful', Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
      }).onError((error, stackTrace){
        showCustomSnackBar('Registration error: $error', Colors.purple);
      });
    }
    catch (e) {
      showCustomSnackBar('Registration error: $e', Colors.purple);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        body: Center(
          child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Text("Login to your Account",
                  style: TextStyle(fontSize: 32 ),
                ),


                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    validator:(val)=> val!.isEmpty ? "Please Enter Email" : null,
                    decoration:const InputDecoration(
                      //labelText: "Enter Email",
                      prefixIcon:  Icon(Icons.mail),
                      //helperText: "Email",
                      hintText: "Enter Email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.blue
                          )
                      ),
                    ),
                  ),


                 TextFormField(
                    controller: _password,
                    obscureText: _password_visibility,
                    validator:(val)=> val!.isEmpty ? "Please Enter Password" : null,
                    decoration: InputDecoration(
                     // labelText: "Enter Password",
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _password_visibility=!_password_visibility;
                          if(_passicon==Icons.remove_red_eye_rounded) _passicon=Icons.visibility_off;
                          else  _passicon=Icons.remove_red_eye_rounded;
                        });
                      },icon: Icon(_passicon),),
                     // helperText: "password",
                      hintText: "Enter Password",
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.blue
                          )
                      ),
                    ),
                  ),


                ElevatedButton(
                  onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const PasswordReset()));
                },
                child: const Text("forgot password ?")
                ),


                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Signup()));
                  },
                  child: Container(
                    width: wi*0.8,
                    height: hi*0.05,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 63, 254),
                      borderRadius: BorderRadius.circular(hi*0.025),
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                  ),


                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(text: ' Sign up',
                                onEnter:(val){
                              print("hii");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                            },
                                style: TextStyle(color: Colors.blueAccent, fontSize: 20)
                            )
                          ]
                      ),
                )


              ],
            ),
           )
         )
        )
      ),
    );
  }
}