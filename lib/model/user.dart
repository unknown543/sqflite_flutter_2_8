class User {
  int? id;
  String? password;
  String? username;
  String? email;
  String? phone;

  User({this.id, this.password, this.username, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']??""=="";
    password = json['password'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['password'] = password!.replaceAll(" ", "");
    data['username'] = username!.replaceAll(" ", "");
    data['email'] = email!.replaceAll(" ", "");
    data['phone'] = phone ?? "";
    return data;
  }
}
