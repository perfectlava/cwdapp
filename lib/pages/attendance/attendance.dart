import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Attendance"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () => context.go("/attendance/register"),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Layout.height(30),
                      vertical: Layout.height(8)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[300]),
                  child: const Text(
                    "Resister new face",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                )),
            InkWell(
                onTap: () => context.go("/attendance/recognition"),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Layout.height(30),
                      vertical: Layout.height(8)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[300]),
                  child: const Text(
                    "Reconize Face(s)",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
