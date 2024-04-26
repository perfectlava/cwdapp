import 'package:cwdapp/models/cover.dart';
import 'package:riverpod/riverpod.dart';

final coverProvider =
    StateNotifierProvider<coverNotifier, List<CoverImage>>((ref) {
  return coverNotifier();
});

class coverNotifier extends StateNotifier<List<CoverImage>> {
  coverNotifier()
      : super([
          CoverImage(title: "Only in Gallery", img: "img1.png"),
          CoverImage(
            title: "Only in list",
            subtitle: "this can only be found in here",
          ),
          CoverImage(
              title: "Everywhere",
              subtitle: 'this link is same in both the botthom and the top',
              img: "img2.png"),
          CoverImage(
              title: "A good title 3",
              subtitle: 'this is a link to google.com',
              img: "img3.png",
              link: "https://www.google.com"),
        ]);
}
