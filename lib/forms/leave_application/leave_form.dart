import 'dart:io';

import 'package:app17000ft_new/forms/leave_application/leave_controller_form.dart';
import 'package:app17000ft_new/forms/select_tour_id/select_controller.dart';
import 'package:app17000ft_new/home/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/custom_appBar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_datePicker.dart';
import '../../components/custom_dropdown_2.dart';
import '../../components/custom_labeltext.dart';
import '../../components/custom_sizedBox.dart';
import '../../components/custom_textField.dart';
import '../../components/error_text.dart';
import '../../constants/color_const.dart';
import '../../helper/responsive_helper.dart';
import '../../home/comOff_service.dart';

class LeaveForm extends StatefulWidget {
  String? userid;
  LeaveForm({
    super.key,
    this.userid,
  });

  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LeaveControllerForm leaveControllerForm =
      Get.put(LeaveControllerForm());
  final leaveController = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();
    print(widget.userid);
    if (widget.userid != null) {
      leaveControllerForm.fetchLeaveData(widget.userid!);
    }

// Fetch dates when needed
    leaveController.fetchAvailableDates(widget.userid!);

  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Leave Application',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<LeaveControllerForm>(
                init: LeaveControllerForm(),
                builder: (leaveControllerForm) {
                  return Form(
                    key: _formKey, // Make sure this is present

                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0), // Adjust this value as needed
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  LabelText(
                                    label: 'CL',
                                  ),
                                  SizedBox(height: 8),
                                  Obx(() => Text(
                                        leaveControllerForm.cl.value.toString(),
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ],
                              ),
                              CustomSizedBox(side: 'width', value: 200),
                              Column(
                                children: [
                                  LabelText(
                                    label: 'SL',
                                  ),
                                  SizedBox(height: 10),
                                  Obx(() => Text(
                                        leaveControllerForm.sl.value.toString(),
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ],
                              ),
                              CustomSizedBox(side: 'width', value: 200),
                              Column(
                                children: [
                                  LabelText(
                                    label: 'EL',
                                  ),
                                  SizedBox(height: 10),
                                  Obx(() => Text(
                                        leaveControllerForm.el.value.toString(),
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          CustomSizedBox(side: 'height', value: 40),
                          Row(
                            children: [
                              // Leave Type Dropdown
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      label: 'Leave Type',
                                      astrick: true,
                                    ),
                                    SizedBox(height: 10),
                                    CustomDropdown(
                                      labelText: '-Select Type-',
                                      selectedValue:
                                          leaveControllerForm.selectedLeaveType,
                                      items: [
                                        DropdownMenuItem(
                                            value: 'Select Type',
                                            child: Text('Select Type')),
                                        DropdownMenuItem(
                                            value: 'SL-Sick Leave',
                                            child: Text('SL - Sick Leave')),
                                        DropdownMenuItem(
                                            value: 'CL-Casual Leave',
                                            child: Text('CL - Casual Leave')),
                                        DropdownMenuItem(
                                            value: 'EL-Earned Leave',
                                            child: Text('EL - Earned Leave')),
                                        DropdownMenuItem(
                                            value: 'CO-Compensatory Leave',
                                            child: Text(
                                                'CO - Compensatory Leave')),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          leaveControllerForm
                                              .selectedLeaveType = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value == 'Select Type') {
                                          return 'Please select a leave type';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 20),

                              // Conditional In Lieu of Date Selector
                              if (leaveControllerForm.selectedLeaveType ==
                                  'CO-Compensatory Leave')
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabelText(
                                          label: 'In Lieu of Date',
                                          astrick: true),
                                      SizedBox(height: 10),
                                      Obx(() => CustomDropdown(
                                        labelText: '-Select Date-',
                                        selectedValue: leaveController.selectedLieuDate,
                                        items: [
                                          DropdownMenuItem(
                                              value: 'Select Date',
                                              child: Text('Select Date')),
                                          ...leaveController.availableDates.map((date) {
                                            return DropdownMenuItem(
                                              value: date,
                                              child: Text(date),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (value) {
                                          leaveController.selectedLieuDate = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value == 'Select Date') {
                                            return 'Please select a date';
                                          }
                                          return null;
                                        },
                                      )),

                                    ],
                                  ),
                                ),
                            ],
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      label: 'Start Date',
                                      astrick: true,
                                    ),
                                    CustomSizedBox(
                                      value: 10,
                                      side: 'height',
                                    ),
                                    CustomDatePicker(
                                      selectedDate:
                                          leaveControllerForm.startDate,
                                      label: 'Start Date',
                                      onDateChanged: (newDate) {
                                        setState(() {
                                          leaveControllerForm.startDate =
                                              newDate;
                                          leaveControllerForm
                                              .updateTotalDays(); // Update total days when start date changes
                                          leaveControllerForm
                                              .validateStartDate(); // Validate the date and set the error message
                                        });
                                      },
                                      isStartDate: true,
                                      errorText: leaveControllerForm
                                          .startDateFieldError, // Pass the error text to the CustomDatePicker
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20), // Spacing between the fields
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      label: 'End Date',
                                      astrick: true,
                                    ),
                                    CustomSizedBox(
                                      value: 10,
                                      side: 'height',
                                    ),
                                    CustomDatePicker(
                                      selectedDate: leaveControllerForm.endDate,
                                      label: 'End Date',

                                      onDateChanged: (newDate) {
                                        setState(() {
                                          leaveControllerForm.endDate = newDate;
                                          leaveControllerForm.updateTotalDays();
                                          leaveControllerForm
                                              .validateEndDate(); // Validate the date and set the error message
// Update total days when end date changes
                                        });
                                      },
                                      isStartDate: false,
                                      errorText: leaveControllerForm
                                          .endDateFieldError, // Pass the error text to the CustomDatePicker
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Number of Leaves Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabelText(
                                        label: 'Number Of Leaves',
                                        astrick: true,
                                      ),
                                      CustomSizedBox(
                                        value: 10,
                                        side: 'height',
                                      ),
                                      CustomTextFormField(
                                        textController: leaveControllerForm
                                            .numberOfLeaveController,
                                        labelText: 'Total Number of Days',
                                        readOnly: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please fill this field';
                                          }

                                          // Convert the string to an integer
                                          int? numberOfDays =
                                              int.tryParse(value);
                                          if (numberOfDays == null) {
                                            return 'Please enter a valid number';
                                          }

                                          // Check if the selected leave type is 'CL-Casual Leave' and the number of days exceeds 3
                                          if (leaveControllerForm
                                                      .selectedLeaveType ==
                                                  'CL-Casual Leave' &&
                                              numberOfDays > 3) {
                                            // Show a dialog when the validation fails
                                            showConfirmationDialog(
                                                'You cannot request more than 3 days for Casual Leave.');
                                            return 'Exceeded limit'; // Return a message for the form validation
                                          }

                                          if (leaveControllerForm
                                                      .selectedLeaveType ==
                                                  'EL-Earned Leave' &&
                                              numberOfDays > 3) {
                                            // Show a dialog when the validation fails
                                            showConfirmationDialog(
                                                'You cannot request more than 3 days for Earned Leave.');
                                            return 'Exceeded limit'; // Return a message for the form validation
                                          }

                                          if (leaveControllerForm
                                              .selectedLeaveType ==
                                              'CO-Compensatory Leave' &&
                                              numberOfDays > 1) {
                                            // Show a dialog when the validation fails
                                            showConfirmationDialog(
                                                'You cannot request more than 1 days for Compensatory Leave.');
                                            return 'Exceeded limit'; // Return a message for the form validation
                                          }

                                          return null; // If all validations pass
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),

                                if (leaveControllerForm.selectedLeaveType ==
                                        'SL-Sick Leave' &&
                                    (int.tryParse(leaveControllerForm
                                                .numberOfLeaveController
                                                .text) ??
                                            0) >
                                        3) ...[
                                  // Upload Medical Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LabelText(
                                          label: 'Upload Medical',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                          value: 10,
                                          side: 'height',
                                        ),
                                        // Upload Field Container
                                        // Upload Field Container
                                        Container(
                                          height: 57,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 2,
                                              color: leaveControllerForm
                                                          .isImageUploadedNumberOfLeaves ==
                                                      false
                                                  ? Colors.grey
                                                  : Colors.red,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: const Text(
                                                'Click or Upload Image'),
                                            trailing: const Icon(
                                              Icons.camera_alt,
                                              color: AppColors.onBackground,
                                            ),
                                            onTap: () {
                                              // Show the bottom sheet for image upload
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    AppColors.primary,
                                                context: context,
                                                builder: (builder) =>
                                                    leaveControllerForm
                                                        .bottomSheet(context),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 8.0),

                                        if (leaveControllerForm
                                            .multipleImage.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              // Show responsive popup with uploaded images in a row
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            'Uploaded Images',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(), // Close the popup
                                                        ),
                                                      ],
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: List.generate(
                                                          leaveControllerForm
                                                              .multipleImage
                                                              .length,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                // Show larger image when tapping on an image
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                Image.file(
                                                                              File(leaveControllerForm.multipleImage[index].path),
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            child:
                                                                                IconButton(
                                                                              icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                children: [
                                                                  Image.file(
                                                                    File(leaveControllerForm
                                                                        .multipleImage[
                                                                            index]
                                                                        .path),
                                                                    width: 100,
                                                                    height: 100,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red),
                                                                      onPressed:
                                                                          () {
                                                                        // Delete image and update UI
                                                                        setState(
                                                                            () {
                                                                          leaveControllerForm
                                                                              .multipleImage
                                                                              .removeAt(index);
                                                                        });
                                                                        Navigator.pop(
                                                                            context); // Close the popup
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Images Uploaded: ${leaveControllerForm.multipleImage.length}',
                                              style: const TextStyle(
                                                  color:
                                                      AppColors.onBackground),
                                            ),
                                          ),

// Display validation error if needed
                                        ErrorText(
                                          isVisible: leaveControllerForm
                                              .validateUploadPhoto,
                                          message: 'Medical Image Required',
                                        ),

// Spacer
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ]),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Message',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                leaveControllerForm.messageController,
                            labelText: 'Write your comments..',
                            maxlines: 2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill this field';
                              }

                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomButton(
                            title: 'Submit',
                            onPressedButton: () async {
                              setState(() {
                                leaveControllerForm
                                    .validateStartDate(); // Validate to update the error text
                                leaveControllerForm
                                    .validateEndDate(); // Validate to update the error text
                                leaveControllerForm.validateUploadPhoto =
                                    leaveControllerForm.multipleImage.isEmpty;
                              });
                              if (_formKey.currentState!.validate()) {
                                // Proceed with form submission
                                // For example, send the data to your server or database
                                print(
                                    "Form is valid! Proceeding with submission...");
                                print('UserId init ${widget.userid}');

                                // Here you can call your submit function, e.g.,
                                // await leaveControllerForm.submit();
                              } else {
                                // Handle the case when the form is not valid
                                print(
                                    "Form is not valid. Please correct the errors.");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Method to show the confirmation dialog
void showConfirmationDialog(String description) {
  Get.dialog(
    Confirmation(
      title: 'Not Valid!',
      desc: description,
      onPressed: () {
        // Handle what happens on 'Yes'
        print('Confirmed!');
        // You can also add any additional logic you need here
      },
      yes: 'Yes',
      no: 'No',
      iconname: Icons.warning, // You can choose any icon you like
    ),
  );
}
