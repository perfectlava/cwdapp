import 'dart:convert';

class CoverImage {
  String title;
  String? subtitle;
  String? img;
  String? description;
  String? link;

  CoverImage(
      {required this.title,
      this.subtitle,
      this.img,
      this.description,
      this.link});

  CoverImage copyWith({
    String? title,
    String? subtitle,
    String? img,
    String? description,
    String? link,
  }) {
    return CoverImage(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      img: img ?? this.img,
      description: description ?? this.description,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'img': img,
      'description': description,
      'link': link,
    };
  }

  factory CoverImage.fromMap(Map<String, dynamic> map) {
    return CoverImage(
      title: map['title'] as String,
      subtitle: map['subtitle'] != null ? map['subtitle'] as String : '',
      img: map['img'] != null ? map['img'] as String : '',
      description:
          map['description'] != null ? map['description'] as String : "error",
      link: map['link'] != null ? map['link'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CoverImage.fromJson(String source) =>
      CoverImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoverImage(title: $title, subtitle: $subtitle, img: $img, description: $description, link: $link)';
  }

  @override
  bool operator ==(covariant CoverImage other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.subtitle == subtitle &&
        other.img == img &&
        other.description == description &&
        other.link == link;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        img.hashCode ^
        description.hashCode ^
        link.hashCode;
  }
}
