import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_booking_app/shared_pref.dart';
import 'package:movie_booking_app/auth.dart';

import 'login.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? id,name,email,image;
  File? imagepicked;
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  getthesharedpref()async{
    id =await SharedpreferenceHelper().getUserId();
    name =await SharedpreferenceHelper().getNameId();
    email=await SharedpreferenceHelper().getEmailId();
    image=await SharedpreferenceHelper().getImageId();
    setState(() {

    });
  }
  @override
  void initState(){
     getthesharedpref();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name==null?Center(
        child: CircularProgressIndicator(),
      ):Container(
        child: Column(
          children: [
            SizedBox(height: 30.0,),
            Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(child: Container(
              padding: EdgeInsets.only(left: 20.0,top:20.0,right: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff1e232c),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: ()async {
                      /*final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                      }*/
                    },
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: MediaQuery.of(context).size.height/5.7,
                        width: MediaQuery.of(context).size.width/2.8 ,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(image!,fit: BoxFit.cover,)
                           // _image != null && image!.isNotEmpty ? Image.file(_image!) : Icon(Icons.person, size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(

                    padding: EdgeInsets.only(bottom: 10.0,top: 10.0,left: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Material(
                      elevation: 5.0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Color(0xff0000ff),
                            size:35.0
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                "Name",
                                style:TextStyle(
                                  color: Colors.black45,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                )
                              ),Text(
                                  name!,
                                  style:TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ]
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(

                    padding: EdgeInsets.only(bottom: 10.0,top: 10.0,left: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Material(
                      elevation: 5.0,
                      child: Row(
                        children: [
                          Icon(
                              Icons.mail_outline,
                              color: Color(0xff0000ff),
                              size:35.0
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                    "Email",
                                    style:TextStyle(
                                      color: Colors.black45,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),Text(
                                    email!,
                                    style:TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  GestureDetector(
                    onTap: (){
                      AuthMethods().SignOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));

                    },
                    child: Container(

                      padding: EdgeInsets.only(bottom: 10.0,top: 10.0,left: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Material(
                        elevation: 5.0,
                        child: Row(
                          children: [
                            Icon(
                                Icons.login_outlined,
                                color: Color(0xff0000ff),
                                size:35.0
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  SizedBox(height: 13.0,),
                                  Text(
                                      "LogOut",
                                      style:TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  SizedBox(height: 13.0,),
                                ]
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),




                ],
              ),
            ))

          ],
        ),
      )
    );
  }
}
