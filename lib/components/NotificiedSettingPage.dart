import 'package:flutter/material.dart';

class NotificiedSettingPage extends StatefulWidget {
  const NotificiedSettingPage({super.key});

  @override
  State<NotificiedSettingPage> createState() => _NotificiedSettingPageState();
}

class _NotificiedSettingPageState extends State<NotificiedSettingPage> {
  // NewsRepository _newsRepository = NewsRepository();
  String selectedCategory = 'Sport'; // Default category

  // ... (other methods remain unchanged)

  void _saveSettings() {
    // Implement your logic to save the selected category
    // print('Selected Category: $selectedCategory');

    // // Call fetchOtherNewsApi with the selected category
    // _newsRepository.fetchOtherNewsApi(selectedCategory).then((headlines) {
    //   // Handle the fetched headlines as needed
    //   print('Fetched headlines: $headlines');
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           NotificationPage(selectedCategory: selectedCategory),
    //     ),
    //   );
    // }).catchError((error) {
    //   // Handle errors
    //   print('Error fetching headlines: $error');
    // });
  }

  // .

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedCategory,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedCategory = newValue;
                  }
                });
              },
              items: <String>['Sport', 'Technology', 'Medical']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
