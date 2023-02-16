import 'dart:convert';

class PersonTitle{

  int? id;
  String title;
  String name;

  PersonTitle({ this.id, required this.title, required this.name});


  /// serialization code will be done in future
  ///JSON Encode
  static Map<String,dynamic> toMap(PersonTitle st)=>{
    "id":st.id,
    "title":st.title,
    "name": st.name,
  };

  static String encodeList(List<PersonTitle> stList) => json.encode(
    stList.map<Map<String,dynamic>>((stList)=>PersonTitle.toMap(stList)).toList(),
  );

  factory PersonTitle.fromJsonList(Map<String,dynamic> jsonData){
    return PersonTitle(
        id:jsonData['id'],
        title: jsonData['title'],
        name: jsonData['name']
    );
  }

  static List<PersonTitle> decodeList(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<PersonTitle>((item) => PersonTitle.fromJsonList(item))
          .toList();

}