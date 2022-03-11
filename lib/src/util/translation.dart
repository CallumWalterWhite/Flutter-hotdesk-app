class Translation {
  late Map<String, String> translations;

  Translation(){
    translations = <String, String>{
      "FULL": "Full day",
      "HALF": "Half day",
      "TIME": "Time"
    };
  }

  //Get translation by key
  String? getTranslation(String key){
    return translations[key];
  }

  //Get key by translation value
  String? getTranslationKey(String value){
    String? tkey;
    translations.forEach((key, t) {
      if (translations[key] == value){
        tkey = key;
        return;
      }
    });
    return tkey;
  }
}