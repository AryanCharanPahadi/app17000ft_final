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
import '../../tourDetails/tour_controller.dart';

class SelectForm extends StatefulWidget {
  const SelectForm({super.key});

  @override
  State<SelectForm> createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  List<String> splitSchoolLists = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

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
            desc: 'Are you sure you want to leave exit?',
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        );
        return shouldExit;
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'School Enrollment Form',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                GetBuilder<SelectController>(
                  init: SelectController(),
                  builder: (schoolEnrolmentController) {
                    return Form(
                      key: _formKey,
                      child: GetBuilder<TourController>(
                        init: TourController(),
                        builder: (tourController) {
                          tourController.fetchTourDetails();
                          List<String> allTourIds = tourController.getLocalTourList
                              .map((e) => e.tourId!) // Ensure tourId is non-nullable
                              .toList();

                          return Column(
                            children: [
                              LabelText(
                                label: 'Select Tour ID (Radio)',
                                astrick: true,
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
                              // Radio button field for selecting tour ID
                              Column(
                                children: tourController.getLocalTourList
                                    .map(
                                      (tour) => RadioListTile<String>(
                                    title: Text(tour.tourId ?? ''),
                                    value: tour.tourId!,
                                    groupValue: schoolEnrolmentController.tourValue,
                                    onChanged: (value) {
                                      setState(() {
                                        // Update the selected tour ID and school list based on the selected tour
                                        schoolEnrolmentController.setTour(value);
                                        splitSchoolLists = tourController.getLocalTourList
                                            .where((e) => e.tourId == value)
                                            .map((e) => e.allSchool!
                                            .split(',')
                                            .map((s) => s.trim())
                                            .toList())
                                            .expand((x) => x)
                                            .toList();
                                      });
                                    },
                                    // Initially no radio button is selected
                                    selected: schoolEnrolmentController.tourValue == tour.tourId,
                                  ),
                                )
                                    .toList(),
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
                              LabelText(
                                label: 'Tour ID',
                                astrick: true,
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
                              // Dropdown shows all tour IDs initially, or the selected one from radio
                              CustomDropdownFormField(
                                focusNode: schoolEnrolmentController.tourIdFocusNode,
                                options: schoolEnrolmentController.tourValue != null
                                    ? [schoolEnrolmentController.tourValue!] // Show only selected value if a radio button is selected
                                    : allTourIds, // Otherwise, show all tour IDs
                                selectedOption: schoolEnrolmentController.tourValue,
                                onChanged: (value) {
                                  // Update school lists when dropdown changes
                                  splitSchoolLists = tourController.getLocalTourList
                                      .where((e) => e.tourId == value)
                                      .map((e) => e.allSchool!
                                      .split(',')
                                      .map((s) => s.trim())
                                      .toList())
                                      .expand((x) => x)
                                      .toList();

                                  setState(() {
                                    schoolEnrolmentController.setSchool(null);
                                    schoolEnrolmentController.setTour(value);
                                  });
                                },
                                labelText: "Select Tour ID",
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
                              LabelText(
                                label: 'School',
                                astrick: true,
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
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
                                ),
                                items: splitSchoolLists,
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Select School",
                                    hintText: "Select School",
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    schoolEnrolmentController.setSchool(value);
                                  });
                                },
                                selectedItem: schoolEnrolmentController.schoolValue,
                              ),
                              CustomSizedBox(
                                value: 20,
                                side: 'height',
                              ),
                            ],
                          );
                        },
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
