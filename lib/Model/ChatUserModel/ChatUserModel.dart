// ignore: file_names
class ChatuserModel {
  String? image;
  String? name;
  String? about;
  String? createdAt;
  String? lastActive;
  bool? isOnline;
  String? id;
  String? pushToken;
  String? email;

  ChatuserModel(
      {this.image,
      this.name,
      this.about,
      this.createdAt,
      this.lastActive,
      this.isOnline,
      this.id,
      this.pushToken,
      this.email});

  ChatuserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    about = json['about'];
    createdAt = json['created_at'];
    lastActive = json['last_active'];
    isOnline = json['is_online'];
    id = json['id'];
    pushToken = json['push_token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
