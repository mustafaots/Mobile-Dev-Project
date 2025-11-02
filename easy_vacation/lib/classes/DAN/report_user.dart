import 'package:flutter/material.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({super.key});

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {

  List problems = [
    'Inappropriate content',
    'Spam or scam',
    'Misleading information',
    'Safety concern',
    'Other'
  ];

  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tell us what's wrong",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  for(var problem in problems)
                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(38, 104, 104, 104)
                        )
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        child: RadioListTile(
                          activeColor: const Color.fromARGB(255, 92, 211, 255),
                          dense: true,
                          value: problem,
                          title: Text(problem, style: TextStyle(fontSize: 14)),
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        ),
                      )
                    )
                  ,
                  SizedBox(height: 10,),
                  Text('Additional Details(Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Provide more information',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(147, 19, 19, 19)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(49, 0, 0, 0)
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 92, 211, 255),
                          width: 2,
                        )
                      )
                    ),
                  ),

                  SizedBox(height: 50,),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: const Color.fromARGB(255, 92, 211, 255)
                      ),
                      onPressed: () {
                        
                      },
                      child: Text(
                        'Submit Report',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}