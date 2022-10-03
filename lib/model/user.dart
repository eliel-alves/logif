import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  String? name;
  String? email;
  String? photo;
  int? score;
  CategoryScore? scoreByCategory;
  Timestamp? creationDate;

  UserDatabase(
      {this.name,
      this.email,
      this.photo,
      this.score,
      this.scoreByCategory,
      this.creationDate});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'url_photo': photo,
        'score': score,
        'completed_categories': scoreByCategory?.toJson(),
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

class CategoryScore {
  String? categoryId;
  int? score;

  CategoryScore({this.categoryId, this.score});

  factory CategoryScore.fromJson(Map<String, dynamic> json) =>
    CategoryScore(categoryId: json['category_id'], score: json['score']);

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'score': score
  };
}
