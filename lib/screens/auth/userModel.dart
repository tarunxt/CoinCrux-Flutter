class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  bool? isSocial;
  String? image;
  List<Topics>? topics = [];
  List<dynamic>? totalRead;
  List<dynamic>? bookMarks = [];

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.isSocial,
      this.topics,
      this.totalRead,
      this.bookMarks,
      this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isSocial = json['isSocial'];
    topics = (json['topics'] as List<dynamic>)
        .map((topicJson) => Topics.fromJson(topicJson))
        .toList();
    totalRead = json['totalRead'];
    bookMarks = json['bookMarks'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['isSocial'] = this.isSocial;
    data['topics'] = topics!.map((e) => e.toJson()).toList();
    data['totalRead'] = this.totalRead;
    data['bookMarks'] = this.bookMarks;
    data['image'] = this.image;
    return data;
  }
}

class Topics {
  int? newsType;
  String? name;

  Topics({this.newsType, this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topics && other.name == name && other.newsType == newsType;
  }

  @override
  int get hashCode => name.hashCode ^ newsType.hashCode;

  Topics.fromJson(Map<String, dynamic> json) {
    newsType = json['newsType'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsType'] = this.newsType;
    data['name'] = this.name;
    return data;
  }
}
