import 'package:easy_vacation/styles/LoginScreenStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<_LoginScreenState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),

        child: Column(
          children: [
            SizedBox(height: 60),

            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: blue,
                shape: BoxShape.circle
              ),
              child:
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/palm.webp'),
                ),
            ),

            SizedBox(height: 10),

            Text('EasyVacation', style: header_2),

            SizedBox(height: 30),

            Text('Welcome Back', style: header_1),

            Text('Login to your account', style: header_3),

            SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: input_decor('Phone Or Email', Icon(Icons.account_circle_outlined) ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: input_decor('Password', Icon(Icons.lock) ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  )
                ],
              )
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: login_button_style,
              onPressed: ()=>{}, 
              child: Text(
                'Login', 
                style: login_text_style
              )
            ),

            SizedBox(height: 20),
            Text('Forgot Password?', style: header_3),
            SizedBox(height: 10),
            Text('Already have an account? Sign Up', style: header_3),
            SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: grey,
                    thickness: 1,
                    endIndent: 10, // space between line and text
                  ),
                ),
                Text(
                  "Or Continue With",
                  style: TextStyle(
                    fontSize: 12,
                    color: grey,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: grey,
                    thickness: 1,
                    indent: 10, // space between text and line
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon( FontAwesomeIcons.google , color: grey ),
                Icon( FontAwesomeIcons.facebook , color: grey )
              ],
            )


          ],
        ),
      ),
    );
  }
}
