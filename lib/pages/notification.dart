import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String selectedCategory;

  NotificationPage({required this.selectedCategory});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // final NewsRepository newsRepository = NewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Notification Page'),
      ),
      body: Container(
          //   padding: const EdgeInsets.all(16.0),
          //   child: FutureBuilder<Headlines>(
          //     future: newsRepository.fetchOtherNewsApi(widget.selectedCategory),
          //     builder: (BuildContext context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         // Display the data in a list or other UI widget
          //         return ListView.builder(
          //           itemCount: snapshot.data!.articles!.length,
          //           itemBuilder: (context, index) {
          //             // Create widgets based on the data
          //             return ListTile(
          //               title: Text(snapshot.data!.articles![index].title ?? ''),
          //               subtitle:
          //                   Text(snapshot.data!.articles![index].description ?? ''),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          ),
    );
  }
}
