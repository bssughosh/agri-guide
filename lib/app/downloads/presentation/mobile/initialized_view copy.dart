import 'package:agri_guide/app/downloads/presentation/widgets/range_widget.dart';
import 'package:agri_guide/core/app_theme.dart';
import 'package:agri_guide/core/widgets/custom_multi_select_form.dart';
import 'package:flutter/material.dart';

import '../downloads_controller.dart';

Widget buildDownloadsInitializedViewMobile({
  @required BuildContext context,
  @required DownloadsPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: controller.isDownloading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () => Future.sync(controller.onWillPopScope),
            child: Container(
              child: Center(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 25, bottom: 10),
                            child: Text(
                              'States: ',
                              style: AppTheme.headingBoldText
                                  .copyWith(fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CustomMultiselectForm(
                            selectedItemList: controller.selectedStates,
                            title: 'Select States',
                            dataSource: controller.stateList,
                            displayKey: 'name',
                            valueKey: 'id',
                            onSavedFunction: controller.updateStateList,
                          ),
                        ),
                        if (controller.selectedStates.length == 1 &&
                            controller.districtList.length > 0)
                          SizedBox(height: 20),
                        if (controller.selectedStates.length == 1 &&
                            controller.districtList.length > 0)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 10),
                              child: Text(
                                'Districts: ',
                                style: AppTheme.headingBoldText
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        if (controller.selectedStates.length == 1 &&
                            controller.districtList.length > 0)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomMultiselectForm(
                              selectedItemList: controller.selectedDistricts,
                              title: 'Select Districts',
                              dataSource: controller.districtList,
                              displayKey: 'name',
                              valueKey: 'id',
                              onSavedFunction: controller.updateDistrictList,
                            ),
                          ),
                        if ((controller.selectedStates.length == 1 &&
                                controller.selectedDistricts.length > 0) ||
                            (controller.selectedStates.length > 1))
                          SizedBox(height: 20),
                        if ((controller.selectedStates.length == 1 &&
                                controller.selectedDistricts.length > 0) ||
                            (controller.selectedStates.length > 1))
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 10),
                              child: Text(
                                'Year Range: ',
                                style: AppTheme.headingBoldText
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        if ((controller.selectedStates.length == 1 &&
                                controller.selectedDistricts.length > 0) ||
                            (controller.selectedStates.length > 1))
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RangeWidget(
                                  title: 'From',
                                  hintText: 'From',
                                  itemsList: controller.yearItems(),
                                  selectedItem: controller.fromText,
                                  onChanged: controller.fromYearUpdated,
                                ),
                                RangeWidget(
                                  title: 'To',
                                  hintText: 'To',
                                  itemsList: controller.yearItems(),
                                  selectedItem: controller.toText,
                                  onChanged: controller.toYearUpdated,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 20),
                        if (controller.downloadedFilesToBeDisplayed.length != 0)
                          Text(
                            'Previously downloaded files',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (controller.downloadedFilesToBeDisplayed.length != 0)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                for (String item
                                    in controller.downloadedFilesToBeDisplayed)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(item),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
