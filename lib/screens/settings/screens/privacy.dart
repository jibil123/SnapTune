import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Privacy & Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
                'Welcome to Snap Tune App. This Privacy Policy outlines how we handle your personal information in the context of using our offline musical app.To enhance your offline musical experience by customizing features based on your preferences , SnapTune employs industry-standard security measures to protect your data from unauthorized access, disclosure, alteration, and destruction. We continually update our security protocols to ensure the utmost protection of your information.SnapTune provides users with control over their data. You can review, edit, or delete your user-generated content within the app. If you wish to delete your account or have any concerns about your privacy, please contact us at Mail : jibilptjibil@gmail.com',
                style: GoogleFonts.abyssinicaSil( 
                    fontSize: 20)),
        ),
      ),
      );
  }
}