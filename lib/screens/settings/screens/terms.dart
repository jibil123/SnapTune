import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Terms and Conditions'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
         child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for choosing SnapTune Before you dive into the world of music with our app, please take a moment to review and understand the terms and conditions outlined below. By accessing or using Snaptune, you are acknowledging that you have read, understood, and agreed to comply with the terms presented herein. If you do not agree with any part of these terms, we kindly ask you to refrain from using our app.'
            ,style: GoogleFonts.abyssinicaSil(
              fontSize: 25)),
               SizedBox(height: 20,),
              Text('Privacy and Data Protection :',style: GoogleFonts.aBeeZee(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('Protecting your privacy is a priority for us. For details on how we collect, use, and safeguard your personal information, please refer to our Privacy Policy, which is an integral part of these terms.'
                            ,style: GoogleFonts.abyssinicaSil(
              fontSize: 20)),
              SizedBox(height: 20,),
              Text('Disclaimer of Warranty :',style: GoogleFonts.aBeeZee(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('SnapTune is provided without any warranties, express or implied. We do not warrant that the app will be error-free or meet your specific requirements. Your use of the app is at your own risk.'
                            ,style: GoogleFonts.abyssinicaSil(
              fontSize: 20)),
              SizedBox(height: 20,),
              Text('License and Usage :',style: GoogleFonts.aBeeZee(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('We hereby grant you a non-exclusive, non-transferable license to use SnapTune for personal, non-commercial purposes. This license is subject to your compliance with these terms. You are expressly prohibited from modifying, reverse engineering, distributing, or attempting unauthorized access to any part of the app.'
                            ,style: GoogleFonts.abyssinicaSil(
              fontSize: 20)),
              SizedBox(height: 20,),
              Text('User Content :',style: GoogleFonts.aBeeZee(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('As a user of SnapTune, you are solely responsible for the content you upload, share, or contribute. We reserve the right to review, moderate, and remove any content that violates these terms or our community guidelines.'
                            ,style: GoogleFonts.abyssinicaSil(
              fontSize: 20)),
              
          ],
         ),
        ),
      ),
    );
  }
}