import 'package:easy_vacation/classes/MAS/post_details/post_details.dart';
import 'package:flutter/material.dart';

class Stays extends StatelessWidget {
  const Stays({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Featured Listings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900
            ),
          ),
        ),

        SizedBox(height: 20,),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for(var i=1; i<=5; i++)

              GestureDetector(
                onTap: ()=>{
                  ///////////////////////////////////////////////////////
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostDetailsScreen()),
                  )
                  ///////////////////////////////////////////////////////
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/apar2.jpg',
                          width: 260,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('BeachFront villa', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text('\$300/night'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_border_outlined,
                                color: Color.fromARGB(255, 255, 207, 14)),
                            SizedBox(width: 4),
                            Text('4.5', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),

        SizedBox(height: 30,),
        
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Text('Recommended for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900
                ),
              ),
              for(var i=0; i<5; i++)
                GestureDetector(
                  onTap: ()=>{
                    ///////////////////////////////////////////////////////
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostDetailsScreen()),
                    )
                    ///////////////////////////////////////////////////////
                  },
                  child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/apar2.jpg',
                            width: double.infinity,
                          ),
                        ),
                        ListTile(
                          title: Text('BeachFront villa', style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text('\$400/night'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_border_outlined,
                                  color: Color.fromARGB(255, 255, 207, 14)),
                              SizedBox(width: 4),
                              Text('4.7', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                )
            ],
          ),
        )
      ],
    );
  }
}