import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../../base_client/baseClient_controller.dart';
import '../../constants/color_const.dart';
import 'leave_service.dart';

class LeaveControllerForm extends GetxController with BaseController {
  final LeaveService _leaveService = LeaveService();

  // Observables for leave types
  var cl = 0.0.obs;
  var sl = 0.0.obs;
  var el = 0.0.obs;

  // Method to fetch leave data based on empId
  Future<void> fetchLeaveData(String empId) async {
    try {
      final leaveData = await _leaveService.fetchRemainingLeaves(empId);
      cl.value = leaveData['CL'];
      sl.value = leaveData['SL'];
      el.value = leaveData['EL'];
    } catch (e) {
      print("Error fetching leave data: $e");
    }
  }

  //Controller Section
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController numberOfLeaveController = TextEditingController();
  final TextEditingController medicalPhotoController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController lieuDateController = TextEditingController();
  //Controller Section


  //Date Section
  DateTime? startDate;
  DateTime? endDate;
  String? startDateFieldError; // Add this line for managing error messages
  String? endDateFieldError; // Add this line for managing error messages

  void validateStartDate() {
    if (startDate == null) {
      startDateFieldError =
      'Please select a start date.'; // Set an error message if no date is selected
    } else {
      startDateFieldError = null; // Clear the error if the date is valid
    }
  }

  validateEndDate() {
    if (endDate == null) {
      endDateFieldError = 'Please select a End date.'; // Example error message
    } else {
      endDateFieldError = null; // Clear the error if the date is valid
    }
  }
  //Date Section


  // update in the number of Leaves
  updateTotalDays() {
    if (startDate != null && endDate != null) {
      // Calculate total days
      final totalDays = endDate!.difference(startDate!).inDays +
          1; // Include both start and end dates
      numberOfLeaveController.text =
          totalDays.toString(); // Update the controller
    } else {
      numberOfLeaveController.clear(); // Clear if dates are not selected
    }
  }
  // update in the number of Leaves


// dropdown Section
  String? selectedLeaveType;
  String? selectedLieuDate;
  // dropdown Section


  // Image Section
  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;

  bool validateUploadPhoto = false;
  bool isImageUploadedNumberOfLeaves = false;


  Future<String> takePhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    List<XFile> selectedImages = [];
    XFile? pickedImage;

    if (source == ImageSource.gallery) {
      selectedImages = await picker.pickMultiImage();
      for (var selectedImage in selectedImages) {
        // Compress each selected image
        String compressedPath = await compressImage(selectedImage.path);
        _multipleImage.add(XFile(compressedPath));
        _imagePaths.add(compressedPath);
      }
      update();
    } else if (source == ImageSource.camera) {
      pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        // Compress the picked image
        String compressedPath = await compressImage(pickedImage.path);
        _multipleImage.add(XFile(compressedPath));
        _imagePaths.add(compressedPath);
      }
      update();
    }

    return _imagePaths.toString();
  }

  Future<String> compressImage(String imagePath) async {
    // Load the image
    final File imageFile = File(imagePath);
    final img.Image? originalImage =
        img.decodeImage(imageFile.readAsBytesSync());

    if (originalImage == null)
      return imagePath; // Return original path if decoding fails

    // Resize the image (optional) and compress
    final img.Image resizedImage =
        img.copyResize(originalImage, width: 768); // Change the width as needed
    final List<int> compressedImage =
        img.encodeJpg(resizedImage, quality: 20); // Adjust quality (0-100)

    // Save the compressed image to a new file
    final Directory appDir = await getTemporaryDirectory();
    final String compressedImagePath =
        '${appDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File compressedFile = File(compressedImagePath);
    await compressedFile.writeAsBytes(compressedImage);

    return compressedImagePath; // Return the path of the compressed image
  }

  Widget bottomSheet(BuildContext context) {
    String? imagePicked;
    PickedFile? imageFile;
    final ImagePicker picker = ImagePicker();
    XFile? image;
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.camera);

                  // uploadFile(userdata.read('customerID'));
                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(
                    ImageSource.gallery,
                  );

                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Image Section
  void clearFields() {
    leaveTypeController.clear();
    startDateController.clear();
    endDateController.clear();
    numberOfLeaveController.clear();
    medicalPhotoController.clear();
    messageController.clear();
    lieuDateController.clear();
    selectedLeaveType = null;
    _multipleImage.clear();
    validateUploadPhoto = false;
    isImageUploadedNumberOfLeaves = false;
    update();
  }
}
