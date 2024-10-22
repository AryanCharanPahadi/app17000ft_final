import 'package:app17000ft_new/forms/select_tour_id/select_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../components/custom_appBar.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_labeltext.dart';
import '../../components/custom_sizedBox.dart';
import '../../components/custom_snackbar.dart';

class SelectForm extends StatelessWidget {
  const SelectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        IconData icon = Icons.check_circle;
        bool shouldExit = await showDialog(
          context: context,
          builder: (_) => Confirmation(
            iconname: icon,
            title: 'Exit Confirmation',
            yes: 'Yes',
            no: 'No',
            desc: 'Are you sure you want to exit?',
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        );
        return shouldExit;
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Select Tour Id',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: Get.put(SelectController()).scrollController,
            child: Column(
              children: [
                GetBuilder<SelectController>(
                  init: SelectController(),
                  builder: (selectController) {
                    selectController.tourController.fetchTourDetails();

                    // Get the list of tour IDs
                    List<String?> tourIds = selectController.tourController.getLocalTourList
                        .map((e) => e.tourId)
                        .toList();

                    return Form(
                      key: selectController.formKey,
                      child: Column(
                        children: [
                          CustomSizedBox(value: 20, side: 'height'),
                          LabelText(label: 'Tour ID (Radio Selection)', astrick: false),
                          CustomSizedBox(value: 20, side: 'height'),
                          // Radio buttons for selecting a tour ID
                          Column(
                            children: tourIds.map((tourId) {
                              return RadioListTile<String?>(
                                title: Text(tourId ?? ''),
                                value: tourId,
                                groupValue: selectController.selectedRadioTourId,
                                onChanged: selectController.lockedTourId == null
                                    ? (value) {
                                  selectController.selectedRadioTourId = value;
                                  selectController.setTour(value);
                                  selectController.updateSchoolList(value);
                                }
                                    : null, // Disable if a tour is locked
                              );
                            }).toList(),
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          LabelText(label: 'Tour ID (Dropdown)', astrick: true),
                          CustomSizedBox(value: 20, side: 'height'),
                          // Dropdown shows only the locked tour ID or selected tour ID
                          CustomDropdownFormField(
                            focusNode: selectController.tourIdFocusNode,
                            options: selectController.lockedTourId != null
                                ? [selectController.lockedTourId!]
                                : selectController.selectedRadioTourId != null
                                ? [selectController.selectedRadioTourId!]
                                : tourIds.where((e) => e != null).cast<String>().toList(),
                            selectedOption: selectController.tourValue ?? selectController.selectedRadioTourId,
                            onChanged: selectController.lockedTourId == null
                                ? (value) {
                              selectController.updateSchoolList(value);
                              selectController.setSchool(null);
                              selectController.setTour(value);
                            }
                                : null, // Disable if tour is locked
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          LabelText(label: 'School', astrick: true),
                          CustomSizedBox(value: 20, side: 'height'),
                          // DropdownSearch showing schools
                          DropdownSearch<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Select School";
                              }
                              return null;
                            },
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                              disabledItemFn: (String s) => s.startsWith('I'),
                              fit: FlexFit.loose,
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item),
                                  selected: isSelected,
                                );
                              },
                            ),
                            items: selectController.lockedSchools != null
                                ? selectController.lockedSchools!
                                : selectController.splitSchoolLists,
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select School",
                                hintText: "Select School",
                              ),
                            ),
                            onChanged: selectController.lockedTourId == null
                                ? (value) {
                              selectController.setSchool(value);
                            }
                                : null, // Disable if tour is locked
                            selectedItem: selectController.schoolValue,
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          // Submit button
                          ElevatedButton(
                            onPressed: selectController.lockedTourId == null &&
                                selectController.splitSchoolLists.isNotEmpty
                                ? () {
                              if (selectController.selectedRadioTourId != null) {
                                // If no specific school is selected, lock all schools
                                List<String> schoolsToLock = selectController.schoolValue != null
                                    ? [selectController.schoolValue!]
                                    : selectController.splitSchoolLists;

                                // Lock the selected tour ID and schools
                                selectController.lockTourAndSchools(
                                  selectController.selectedRadioTourId!,
                                  schoolsToLock,
                                );
                                customSnackbar(
                                  'Tour Locked',
                                  'Your tour ID and associated schools have been locked',
                                  Colors.green,
                                  Colors.white,
                                  Icons.lock,
                                );

                              } else {
                                customSnackbar(
                                  'Error',
                                  'Please select a tour ID',
                                  Colors.red,
                                  Colors.white,
                                  Icons.error,
                                );
                              }
                            }
                                : null, // Disable if no tour is selected or locked
                            child: const Text('Lock Tour and School'),
                          ),
                          // Unlock button (only visible if a tour is locked)
                          if (selectController.lockedTourId != null) ...[
                            CustomSizedBox(value: 20, side: 'height'),
                            ElevatedButton(
                              onPressed: () {
                                selectController.unlockTourAndSchools();
                                customSnackbar(
                                  'Logged Out',
                                  'All selections have been cleared.',
                                  Colors.blue,
                                  Colors.white,
                                  Icons.logout,
                                );

                              },
                              child: const Text('Unlock Tour and School'),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
