import 'package:cwdapp/pages/home/gallery.dart';
import 'package:cwdapp/pages/home/main_list.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            height: Layout.height(60),
            width: Layout.height(140),
            child: const Center(
              child: Text(
                'Have you registered your face?',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          // content: SizedBox(
          //   height: Layout.height(8),
          // ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      context.go("/attendance/recognition");
                    },
                    child: SizedBox(
                        height: Layout.width(30),
                        child: const Center(child: Text('Yes'))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      context.go("/attendance/register");
                    },
                    child: SizedBox(
                        width: Layout.width(70),
                        child: const Center(child: Text('No'))),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<DocumentSnapshot>(
    //     stream: FirebaseFirestore.instance
    //         .collection('others')
    //         .doc('links')
    //         .snapshots(),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       }
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return const Scaffold(body: CircularProgressIndicator());
    //         default:
    //           if (!snapshot.hasData || snapshot.data!.data() == null) {
    //             return const Text('No data found');
    //           } else {
    //             String link = snapshot.data![
    //                 'attendance']; // Assuming 'link' is the field name in Firestore
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: Layout.height(100)),
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home Page"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.checklist_rtl),
                title: const Text("Attendance"),
                onTap: () {
                  _onTap(context);
                },
                // Link(
                //     target: LinkTarget.defaultTarget,
                //     uri: Uri.parse(link),
                //     builder: (context, followLink) =>
                //         GestureDetector(
                //             onTap: followLink,
                //             child: const Text("Attendance"))),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Syosset CWD Club"),
        ),
        body: const Column(children: [Gallery(), Expanded(child: MainList())]));
    // }
    // }
    // }
    // );
  }
}
