import 'package:cwdapp/models/cover.dart';
import 'package:cwdapp/providers/cover_provider.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:cwdapp/widgets/big_text.dart';
import 'package:cwdapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/link.dart';

class MainList extends ConsumerStatefulWidget {
  const MainList({super.key});

  @override
  ConsumerState<MainList> createState() => _MainListState();
}

class _MainListState extends ConsumerState<MainList> {
  @override
  Widget build(BuildContext context) {
    List<CoverImage> covers = [];
    for (var element in ref.read(coverProvider)) {
      if (element.subtitle.isNotEmpty) {
        covers.add(element);
      }
    }
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: Layout.height(10)),
        itemCount: covers.length,
        itemBuilder: (context, index) {
          return Link(
            target: LinkTarget.defaultTarget,
            uri: Uri.parse(covers[index].link),
            builder: (context, followLink) => InkWell(
                onTap: covers[index].link.isEmpty
                    ? () => context.go("/detail", extra: covers[index])
                    : followLink,
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Layout.width(30),
                        vertical: Layout.height(8)),
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
                    ))),
          );
        });
  }
}
