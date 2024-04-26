import 'package:cwdapp/models/cover.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Detail extends StatelessWidget {
  final CoverImage cover;
  const Detail({super.key, required this.cover});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(cover.title),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Stack(children: [
          //background image
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: Layout.height(300),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/${cover.img}"))),
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Layout.height(273),
              child: Container(
                  padding: EdgeInsets.only(
                      left: Layout.width(20),
                      right: Layout.width(20),
                      top: Layout.height(20)),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 15.0,
                        )
                      ],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Layout.height(25)),
                      ),
                      color: Colors.blueAccent[100]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(cover.title,
                          style: TextStyle(
                              fontSize: Layout.height(28),
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: Layout.height(20),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Layout.height(35)),
                                child: Text(
                                  cover.description,
                                  style: TextStyle(
                                      fontSize: Layout.height(16),
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold),
                                ),
                              ))),
                    ],
                  ))),
        ]));
  }
}
