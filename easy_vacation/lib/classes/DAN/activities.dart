import 'package:flutter/material.dart';

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Featured Activities',
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/skiing.jpg',
                          width: 260,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('skiing', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text('Chrea'),
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
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/bike_riding.jpg',
                        width: double.infinity,
                      ),
                    ),
                    ListTile(
                      title: Text('Quad riding', style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text('Sahara'),
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
            ],
          ),
        )
      ],
    );
  }
}