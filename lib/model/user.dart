import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  String? name;
  String? email;
  String? photo;
  int? score;
  List<String>? completedCategories;
  Timestamp? creationDate;

  UserDatabase(
      {this.name,
      this.email,
      this.photo,
      this.score,
      this.completedCategories,
      this.creationDate});

  factory UserDatabase.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDatabase(
      name: data?['name'],
      email: data?['email'],
      photo: data?['url_photo'],
      score: data?['score'],
      creationDate: data?['creation_date'],
      completedCategories: data?['completed_categories'] is Iterable
          ? List.from(data?['completed_categories'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photo != null) "url_photo": photo,
      if (score != null) "score": score,
      if (creationDate != null) "creation_date": creationDate,
      if (completedCategories != null)
        "completed_categories": completedCategories,
    };
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'url_photo': photo,
        'score': score,
        'completed_categories': completedCategories,
        'creation_date': creationDate,
      };

  static UserDatabase fromJson(Map<String, dynamic> json) => UserDatabase(
        name: json['name'],
        email: json['email'],
        photo: json['url_photo'],
        score: json['score'],
        creationDate: json['creation_date'] as Timestamp,
      );
}
