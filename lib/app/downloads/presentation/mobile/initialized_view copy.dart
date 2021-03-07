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
                        Text(
                          'States: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
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
                          Text(
                            'Districts: ',
                            style:
                                AppTheme.headingBoldText.copyWith(fontSize: 17),
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
                              onSavedFunction: controller.updateStateList,
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
