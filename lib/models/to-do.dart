class ToDos{
  final String title;
  final String? description;

  ToDos({required this.title, this.description});

  ToDos.fromJson(Map<dynamic,dynamic> json):
      title= json['title'] as String,
      description= json['description'] as String?;

  Map<dynamic, dynamic> toJson() => <dynamic,dynamic> {
    'name':title,
    'description':description,
  };

  Map<String, dynamic> toMap() => <String,dynamic> {
    'name':title,
    'description':description,
  };
}