import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/database.dart';
import 'package:movie_booking_app/shared_pref.dart';
import 'package:random_string/random_string.dart';

import 'bottomnav.dart';
import 'login.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email="",password="",name="";
  TextEditingController namecontroller= new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController mailcontroller=new TextEditingController();
  registration() async{
    if(password != null &&
       namecontroller.text != "" &&
       mailcontroller.text !=""){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.
          createUserWithEmailAndPassword(email: email, password: password);
        String id = userCredential.user?.uid ?? randomAlphaNumeric(10);
        Map<String,dynamic> userInfoMap={
          "Name":namecontroller.text,
          "Email":mailcontroller.text,
          "Id":id,
          "Image":"https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D"
        };
        await SharedpreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedpreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedpreferenceHelper().saveUserId(id);
        await SharedpreferenceHelper().saveUserImage("https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D");
        await DatabaseMethods().addUserDetails(userInfoMap, id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Register Successfully",
                style: TextStyle(fontSize: 18.0),
              ),
            )
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNav()));

      } on FirebaseAuthException catch (e){
        if(e.code == 'weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }else if(e.code == 'email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Accont Already exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff14141d),
      body:SingleChildScrollView(
        child: Container(
          child:Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/signin.png"),
                Padding(
                    padding: EdgeInsets.only(left:30.0,right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold
                          ),

                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Name",
                          style: TextStyle(
                              color: Color.fromARGB(157, 255, 255, 255),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        TextField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                            hintText: "Enter Name",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(219, 255, 255, 255),
                            ),
                            suffixIcon: Icon(Icons.person,color: Colors.white,)
                          ),
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                              color: Color.fromARGB(157, 255, 255, 255),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        TextField(
                          controller: mailcontroller,
                          decoration: InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(219, 255, 255, 255),
                              ),
                              suffixIcon: Icon(Icons.email,color: Colors.white,)
                          ),
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(
                              color: Color.fromARGB(157, 255, 255, 255),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(219, 255, 255, 255),
                              ),
                              suffixIcon: Icon(Icons.password,color: Colors.white,)
                          ),
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           GestureDetector(
                             onTap: (){
                                if(namecontroller.text!="" && mailcontroller.text!="" && passwordController!=""){
                                  setState(() {
                                      name=namecontroller.text;
                                      email=mailcontroller.text;
                                      password=passwordController.text;
                                  });
                                  registration();
                                }
                             },
                             child: Container(
                               width: 170,
                               padding: EdgeInsets.all(10),
                               decoration: BoxDecoration(
                                 color: Color(0xff5953fc),
                                 borderRadius: BorderRadius.circular(30)
                               ),
                               child: Center(
                                 child: Text(
                                   "SignUp",
                                   style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 25.0,
                                     fontWeight: FontWeight.bold
                                   ),
                                 ),
                               ),
                             ),
                           )
                         ],
                       ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(
                        "Already have an account ? ",
                        style: TextStyle(
                            color: Color.fromARGB(157, 255, 255, 255),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));

                        },
                        child: Text(
                            "Login",
                            style: TextStyle(
                                color:Color(0xff5953fc),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500
                            ),),
                      )

                      ]
                    )],
                    ),

                )
              ],
            ),
          )
        ),
      )
    );
  }
}
