import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;

class JobInfoPage extends StatefulWidget {
  @override
  _JobInfoPageState createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  String companyLogoUrl = ""; // Placeholder for company logo URL
  String companyName = ""; // Placeholder for company name
  String jobRequirements = ""; // Placeholder for job requirements

  // Function to fetch job info from API
  Future<void> fetchJobInfo() async {
    final response = await http
        .get(Uri.parse('b22819da1dmshe1695fc7716dd61p167019jsn9f69a6d51ad2'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        companyLogoUrl = jsonData['company_logo_url'];
        companyName = jsonData['company_name'];
        jobRequirements = jsonData['job_requirements'];
      });
    } else {
      throw Exception('Failed to load job info');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Info'),
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            )),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (companyLogoUrl.isNotEmpty)
                Image.network(
                  companyLogoUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              Text(
                companyName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  jobRequirements,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
