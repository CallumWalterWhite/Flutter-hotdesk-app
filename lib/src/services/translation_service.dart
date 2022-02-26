import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

class TranslationService {
  late Map<String, String> translations;

  TranslationService(){
    init();
  }

  Future <Null> init() async {
    final String response = await rootBundle.loadString('assets/translations/en-gb/translations.json');
    translations = await json.decode(response);
  }

  String? getTranslation(String key){
    return translations[key];
  }

  String? getTranslationKey(String value){
    String? tkey;
    translations.forEach((key, value) {
      if (translations[key] == value){
        tkey = key;
        return;
      }
    });
    return tkey;
  }
}