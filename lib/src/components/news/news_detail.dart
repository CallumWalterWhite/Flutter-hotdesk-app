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
      body: Column(
        children: [
          Image.network(
            imageURL,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Paragraph(news.body),
          ),
        ],
      )
  );
}