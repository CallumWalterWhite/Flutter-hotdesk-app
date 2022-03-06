import 'package:flutter/material.dart';

import '../../entities/news.dart';
import '../../widgets/widget.dart';

class NewsDetail extends StatelessWidget {
  const NewsDetail(this.news, this.imageURL);
  final News news;
  final String imageURL;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Container(
        alignment: Alignment.center,
        width: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageURL,
              fit: BoxFit.cover,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Paragraph(news.body),
            ),
          ],
        ),
      )
  );
}