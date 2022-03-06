
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

import '../../entities/news.dart';
import '../../persistence/storage_repository.dart';
import '../../services/news_service.dart';
import '../../util/colour_palette.dart';
import 'news_detail.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({Key? key}) : super(key: key);

  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  final NewsService _newsService = Ioc().use('newsService');
  final StorageRepository _storageRepository = Ioc().use('storageRepository');
  late List<News> news;
  late Map<int, String> newsImages = {};
  late bool newsLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <void> init() async {
    await loadNewsData();
  }

  Future<void> loadNewsData() async {
    news = await _newsService.getAll();
    for (var element in news) {
      newsImages[element.id] = await _storageRepository.downloadURL(element.image);
    }
    setState(() {
      newsLoaded = true;
    });
  }

  Widget buildWidget(){
    if(newsLoaded){
      return GridView.builder(
          padding: const EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: news.length,
          itemBuilder: (BuildContext ctx, index) {
            return GridTile(
              key: ValueKey(news[index].id),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
                ),
                child: Image.network(
                  newsImages[news[index].id] as String,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewsDetail(news[index], newsImages[news[index].id] as String),
                  ));
                },
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  news[index].title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          });
    }
    else{
      return const Center(child: Text('loading...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: mainColour),
        title: const Text("Company news", style: TextStyle(color: mainColour)),
        backgroundColor: Colors.white,
      ),
      body: buildWidget()
    );
  }
}