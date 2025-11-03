// ConfirmListingScreen.dart
import 'package:easy_vacation/classes/DAN/home_screen.dart';
import 'package:easy_vacation/shared/themes.dart';
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
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text("Confirm & Post"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: AppTheme.cardDecoration,
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
                    _buildSummaryRow("Base Price", "\$50"),
                    const SizedBox(height: 6),
                    _buildSummaryRow("Service Fee", "\$5"),
                    const Divider(height: 20, thickness: 1),
                    _buildSummaryRow(
                      "Total",
                      "\$55",
                      isBold: true,
                      isColored: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: AppTheme.primaryColor),
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
            Container(
              decoration: AppTheme.cardDecoration,
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
                  activeColor: AppTheme.primaryColor,
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
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                style: AppTheme.primaryButtonStyle,
                child: const Text(
                  "Post Listing",
                  style: TextStyle(fontSize: 18, color: AppTheme.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool isColored = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isColored ? AppTheme.primaryColor : null,
          ),
        ),
      ],
    );
  }
}