import 'package:ioc/ioc.dart';
import 'package:itec27001/src/services/profile_service.dart';

import '../entities/news.dart';
import '../entities/profile.dart';
import '../persistence/news_repository.dart';

class NewsService {
  final NewsRepository _newsRepository = Ioc().use('newsRepository');
  final ProfileService _profileService = Ioc().use('profileService');


  Future<List<News>> getAll() async {
    Profile profile = await _profileService.get();
    return await _newsRepository.getAll(profile.department);
  }
}