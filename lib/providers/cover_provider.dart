import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwdapp/models/cover.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final galleryProvider = FutureProvider<List<CoverImage>>((ref) async {
  QuerySnapshot data = await FirebaseFirestore.instance
      .collection("covers")
      .where("img", isNull: false)
      .get();
  List<CoverImage> list = [];
  for (var id in data.docs) {
    CoverImage newCover = CoverImage.fromMap(id.data() as Map<String, dynamic>);
    list.add(newCover);
  }
  return list;
});

final mainListProvider = FutureProvider<List<CoverImage>>((ref) async {
  QuerySnapshot data = await FirebaseFirestore.instance
      .collection("covers")
      .where("subtitle", isNull: false)
      .get();
  List<CoverImage> list = [];
  for (var id in data.docs) {
    CoverImage newCover = CoverImage.fromMap(id.data() as Map<String, dynamic>);
    list.add(newCover);
  }
  return list;
});