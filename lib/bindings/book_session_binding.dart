import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/book_session_controller.dart';

class BookSessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookSessionController>(() => BookSessionController());
  }
}

