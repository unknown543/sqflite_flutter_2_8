import 'dart:convert';

class TestData {
  int? id;
  Data? data;

  TestData({this.id, this.data});

  TestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data =
        json['data'] != null ? Data.fromJson(jsonDecode(json['data'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? id;
  String? title;
  String? body;
  List<Users>? users;

  Data({this.userId, this.id, this.title, this.body, this.users});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? username;
  String? email;

  Users({this.id, this.name, this.username, this.email});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    return data;
  }
}
