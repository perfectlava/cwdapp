import 'package:cwdapp/models/cover.dart';
import 'package:cwdapp/pages/attendance/recognition_page.dart';
import 'package:cwdapp/pages/attendance/register_page.dart';
import 'package:cwdapp/pages/detail.dart';
import 'package:cwdapp/pages/home/home.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomePage()),
  // GoRoute(path: '/attendance', builder: (context, state) => const Attendance()),
  GoRoute(
      path: '/attendance/register',
      builder: (context, state) => const Register()),
  GoRoute(
      path: '/attendance/recognition',
      builder: (context, state) => const RecognitionScreen()),
  GoRoute(
      path: '/detail',
      builder: (context, state) => Detail(
            cover: state.extra as CoverImage,
          )),
]);

GoRouter createRouter() {
  return _router;
}
