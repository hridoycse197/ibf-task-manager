import 'package:get/get.dart';
import '../views/home_screen.dart';
import '../views/task_details_screen.dart';

/// App navigation pages/routes
class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.taskDetails,
      page: () => const TaskDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}

/// Route paths
class Routes {
  static const home = '/';
  static const taskDetails = '/task-details';
}
