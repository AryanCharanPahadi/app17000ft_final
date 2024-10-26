import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_model.dart';
import 'package:get/get.dart';

class TourController extends GetxController {
  List<TourDetails> localTourList = [];
  List<TourDetails> get getLocalTourList => localTourList;

  @override
  void onInit() {
    super.onInit();
    fetchTourDetails(); // Automatically fetch tour details when the controller is initialized
  }

  fetchTourDetails() async {
    localTourList = await LocalDbController().fetchLocalTourDetails();
    update(); // Notify listeners that the list has been updated
  }
  Future<void> clearTourDetailsOnLogout() async {
    await SqfliteDatabaseHelper().delete('tour_details');  // Clear from local DB
    localTourList.clear();  // Clear in-memory list
    update();  // Update UI or state
  }
}
