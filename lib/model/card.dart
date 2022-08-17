// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryCard {
  String content;
  int order;
  String urlButton;
  CategoryCard({
    required this.content,
    required this.order,
    required this.urlButton,
  });

  CategoryCard copyWith({
    String? content,
    int? order,
    String? urlButton,
  }) {
    return CategoryCard(
      content: content ?? this.content,
      order: order ?? this.order,
      urlButton: urlButton ?? this.urlButton,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'order': order,
      'urlButton': urlButton,
    };
  }

  factory CategoryCard.fromMap(Map<String, dynamic> map) {
    return CategoryCard(
      content: map['content'] as String,
      order: map['order'] as int,
      urlButton: map['urlButton'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryCard.fromJson(String source) =>
      CategoryCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Card(content: $content, order: $order, urlButton: $urlButton)';

  @override
  bool operator ==(covariant CategoryCard other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        other.order == order &&
        other.urlButton == urlButton;
  }

  @override
  int get hashCode => content.hashCode ^ order.hashCode ^ urlButton.hashCode;
}
