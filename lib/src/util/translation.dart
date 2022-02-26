class Translation {
  late Map<String, String> translations;

  Translation(){
    translations = <String, String>{
      "FULL": "Full day",
      "HALF": "Half day"
    };
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