import 'package:cwdapp/models/cover.dart';
import 'package:riverpod/riverpod.dart';

final coverProvider =
    StateNotifierProvider<coverNotifier, List<CoverImage>>((ref) {
  return coverNotifier();
});

class coverNotifier extends StateNotifier<List<CoverImage>> {
  coverNotifier()
      : super([
          CoverImage(
              title: "A good title 1",
              subtitle:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              img: "img1.png"),
          CoverImage(
              title: "A good title 2", subtitle: 'subtitle', img: "img2.png"),
          CoverImage(
              title: "A good title 3",
              subtitle: 'subtitle',
              img: "img3.png",
              link: "https://www.google.com"),
        ]);
}
