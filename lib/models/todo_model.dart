class TodoModel {
  final String id;
  final String title;
  final bool isCompleted;
  TodoModel(this.id, this.title, this.isCompleted);
  toMap(){
    return {
      "id": id,
      "title": title,
      "isCompleted": isCompleted,
    };
  }
  static TodoModel fromMap(Map map){
    return TodoModel(map["id"], map["title"], map["isCompleted"]);
  } 
}
