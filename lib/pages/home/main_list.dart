import 'package:cwdapp/models/cover.dart';
import 'package:cwdapp/providers/cover_provider.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:cwdapp/widgets/big_text.dart';
import 'package:cwdapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainList extends ConsumerStatefulWidget {
  const MainList({super.key});

  @override
  ConsumerState<MainList> createState() => _MainListState();
}

// final List<CoverImage> covers = [
//   CoverImage(
//       title: "title1",
//       subtitle:
//           "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//       img: "img1.png"),
//   CoverImage(title: "title2", subtitle: 'subtitle', img: "img2.png"),
//   CoverImage(title: "title3", subtitle: 'subtitle', img: "img3.png"),
//   CoverImage(title: "title1", subtitle: 'subtitle', img: "img1.png"),
// ];

class _MainListState extends ConsumerState<MainList> {
  @override
  Widget build(BuildContext context) {
  List<CoverImage> covers = ref.watch(coverProvider);
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: Layout.height(10)),
        itemCount: covers.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                context.go("/detail", extra: covers[index]);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Layout.width(30), vertical: Layout.height(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.circular(Layout.height(20))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Layout.height(20),
                                right: Layout.height(10),
                                left: Layout.height(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(
                                    text: covers[index].title,
                                    color: Colors.black87),
                                SizedBox(
                                  height: Layout.height(12),
                                ),
                                TextWidget(
                                    text: covers[index].subtitle,
                                    color: const Color(0xFFccc7c5)),
                                SizedBox(
                                  height: Layout.height(10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )));
        });
  }
}
