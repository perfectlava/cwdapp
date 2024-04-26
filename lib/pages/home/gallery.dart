import 'package:cwdapp/models/cover.dart';
import 'package:cwdapp/providers/cover_provider.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

class Gallery extends ConsumerStatefulWidget {
  const Gallery({super.key});

  @override
  ConsumerState<Gallery> createState() => _GalleryState();
}

class _GalleryState extends ConsumerState<Gallery> {
  final PageController ctrl = PageController(
    viewportFraction: 0.75,
  );

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int pos = ctrl.page!.round();
      if (currentPage != pos) {
        {
          setState(() {
            currentPage = pos;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  _buildStoryPage(bool active, CoverImage cover) {
    // Animated Properties
    // final double blur = active ? 100 : 0;
    // final double offset = active ? 10 : 0;
    final double top = active ? 50 : 75;

    return Link(
        target: LinkTarget.defaultTarget,
        uri: Uri.parse(cover.link),
        builder: (context, followLink) => InkWell(
              onTap: cover.link.isEmpty
                  ? () => context.go("/detail", extra: cover)
                  : followLink,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
                margin: EdgeInsets.only(
                    top: Layout.height(top),
                    bottom: Layout.height(20),
                    right: Layout.height(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/${cover.img}"),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    List<CoverImage> covers = ref.watch(coverProvider);
    return Column(children: [
      SizedBox(
        height: Layout.height(Layout.getScreenWidth() > 700 ? 700 : 350),
        child: PageView.builder(
            controller: ctrl,
            itemCount: covers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, int index) {
              // Active page
              bool active = index == currentPage;
              return _buildStoryPage(active, covers[index]);
            }),
      ),
      DotsIndicator(
        dotsCount: covers.length,
        position: currentPage,
        decorator: DotsDecorator(
          size: const Size.square(9.0),
          activeSize: const Size(18.0, 9.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    ]);
  }
}
