class Tarefa {
  String? title;
  bool? ok;

  Tarefa({this.title, this.ok});

  Tarefa.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    ok = json['ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['ok'] = ok;
    return data;
  }
}
