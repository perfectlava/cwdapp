import 'package:cwdapp/pages/home/gallery.dart';
import 'package:cwdapp/pages/home/main_list.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: Layout.height(100)),
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home Page"),
                onTap: () => context.go("/"),
              ),
              ListTile(
                leading: const Icon(Icons.checklist_rtl),
                title: Link(
                    target: LinkTarget.defaultTarget,
                    uri: Uri.parse(
                        "https://docs.google.com/forms/d/e/1FAIpQLSeZv0-js4ZQ5-O3MWs305h8hyIkLnLrufeANhMDMoZ3Kx9Ifg/viewform?usp=sf_link"),
                    builder: (context, followLink) => GestureDetector(
                        onTap: followLink,
                        child: const Text("Attendance"))),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Syosset CWD Club"),
        ),
        body: const Column(children: [Gallery(), Expanded(child: MainList())]));
  }
}
