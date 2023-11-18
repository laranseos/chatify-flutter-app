

class FirebaseContactModel {
  String? name,phone;

  FirebaseContactModel(
      {this.name,
        this.phone});

  FirebaseContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phoneNumber'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phone;

    return data;
  }
}

