import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  final econtroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Forget Password',style: TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),),
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  'Welcome to the Forgot Password Page! If you\'ve forgotten your password, follow these steps: '
                      '\n\n1) Enter your account\'s associated email address. '
                      '\n2) Click "Reset Password." '
                      '\n3) Check your email for a password reset link. '
                      '\n4) Open the email and click the link. '
                      '\n5) Create a new, strong password. '
                      '\n6) Confirm the password reset. '
                      '\n\nFor any issues or questions, contact our support team. '
                      '\n\nThank you for choosing our service!',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing:0.5
                  ),

                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.all(30),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller:econtroller,
                  style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18
                  ),
                  // obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                      hintText: "Enter E-mail",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff4c505b),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: InkWell(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email:econtroller.text);
                      Fluttertoast.showToast(
                        msg: "We have sent an email to recover your password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Failed to send password reset email",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.white,
                        textColor: Colors.red,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    child: const Icon(Icons.send_sharp,color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Forgot Password'),
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           TextField(controller:emailcontroller,
    //             style: const TextStyle(),
    //             obscureText: false,
    //             decoration: InputDecoration(
    //                 fillColor: Colors.white,
    //                 filled: true,
    //                 hintText: "Email",
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(10),
    //                 )
    //             ),
    //           ),
    //           CircleAvatar(
    //             radius: 30,
    //             backgroundColor: const Color(0xff4c505b),
    //             child: IconButton(
    //                 color: Colors.white,
    //                 onPressed: () {
    //                   FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text);
    //                 },
    //                 icon: const Icon(
    //
    //                   Icons.arrow_circle_up_rounded,
    //                 )),
    //           ),
    //           const SizedBox(
    //             height: 80,
    //           ),
    //
    //         ],
    //
    //       ),
    //
    //     )
    // );

  }
}