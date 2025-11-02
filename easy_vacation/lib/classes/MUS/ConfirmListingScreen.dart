import 'package:easy_vacation/classes/DAN/home_screen.dart';
import 'package:easy_vacation/shared/colors.dart';
import 'package:flutter/material.dart';

class ConfirmAndPostScreen extends StatefulWidget {
  const ConfirmAndPostScreen({super.key});

  @override
  State<ConfirmAndPostScreen> createState() => _ConfirmAndPostScreenState();
}

class _ConfirmAndPostScreenState extends State<ConfirmAndPostScreen> {
  bool agreedCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Confirm & Post"),
        backgroundColor: blue,
        foregroundColor: white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary & Plan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Base Price"),
                        Text("\$50"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Service Fee"),
                        Text("\$5"),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$55",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text("Subscription: \n Premium Plan (30 days)"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Suggestions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "✔️ Add more photos to attract attention.\n"
                      "✔️ Highlight special offers.\n"
                      "✔️ Include contact information for faster bookings.",
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: agreedCheck,
                  onChanged: (val) {
                    setState(() => agreedCheck = val!);
                  },
                  activeColor: Colors.blueAccent,
                ),
                const Expanded(
                  child: Text(
                    "I agree to the Terms of Service and confirm all details are correct.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: agreedCheck
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Listing posted successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : ()=>{
                      ///////////////////////////////////////////////////////
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      )
                      ///////////////////////////////////////////////////////
                    }, // disabled if not agreed

                    
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Post Listing",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
