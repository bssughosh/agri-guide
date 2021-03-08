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
                // child: Stack(
                //   children: [
                //     Center(
                //       child: Container(
                //         child: SingleChildScrollView(
                //           child: Column(
                //             children: [
                //               SizedBox(
                //                 height: 30,
                //               ),
                //               LocationSelectionBar(
                //                 controller: controller,
                //                 selectionListType: SelectionListType.STATE,
                //                 isWeb: false,
                //               ),
                //               if (controller.selectedStates.length == 1 &&
                //                   controller.districtList.length > 0)
                //                 LocationSelectionBar(
                //                   controller: controller,
                //                   selectionListType: SelectionListType.DISTRICT,
                //                   isWeb: false,
                //                 ),
                //               if ((controller.selectedStates.length == 1 &&
                //                       controller.selectedDistricts.length > 0) ||
                //                   (controller.selectedStates.length > 1))
                //                 Container(
                //                   width: MediaQuery.of(context).size.width,
                //                   margin: EdgeInsets.all(10),
                //                   padding: EdgeInsets.fromLTRB(20, 5, 25, 5),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     children: <Widget>[
                //                       Text(
                //                         'Range of Data',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       SizedBox(height: 10),
                //                       Row(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: <Widget>[
                //                           Expanded(
                //                             child: RangeWidget(
                //                               controller: controller,
                //                               isFrom: true,
                //                             ),
                //                           ),
                //                           SizedBox(width: 15),
                //                           Expanded(
                //                             child: RangeWidget(
                //                               controller: controller,
                //                               isFrom: false,
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               if ((controller.selectedStates.length == 1 &&
                //                       controller.selectedDistricts.length > 0) ||
                //                   (controller.selectedStates.length > 1))
                //                 DownloadParamsSelectionBar(
                //                   controller: controller,
                //                   isWeb: false,
                //                 ),
                //               if (((controller.selectedStates.length == 1 &&
                //                           controller.selectedDistricts.length >
                //                               0) ||
                //                       (controller.selectedStates.length > 1)) &&
                //                   controller.selectedParams.length > 0)
                //                 TextButton(
                //                   child: Text(
                //                     'Submit',
                //                     style:
                //                         AppTheme.navigationTabSelectedTextStyle,
                //                   ),
                //                   style: ButtonStyle(
                //                     backgroundColor:
                //                         MaterialStateProperty.all<Color>(
                //                             AppTheme.navigationSelectedColor),
                //                     overlayColor:
                //                         MaterialStateProperty.all<Color>(
                //                             AppTheme.secondaryColor),
                //                   ),
                //                   onPressed: () {
                //                     controller.downloadFilesMobile();
                //                   },
                //                 ),
                //               SizedBox(height: 20),
                //               if (controller
                //                       .downloadedFilesToBeDisplayed.length !=
                //                   0)
                //                 Text(
                //                   'Previously downloaded files',
                //                   style: TextStyle(fontWeight: FontWeight.bold),
                //                 ),
                //               if (controller
                //                       .downloadedFilesToBeDisplayed.length !=
                //                   0)
                //                 Container(
                //                   width: MediaQuery.of(context).size.width,
                //                   margin: EdgeInsets.symmetric(
                //                       vertical: 10, horizontal: 10),
                //                   child: Column(
                //                     children: [
                //                       for (String item in controller
                //                           .downloadedFilesToBeDisplayed)
                //                         Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           child: Container(
                //                             child: Padding(
                //                               padding: const EdgeInsets.all(8.0),
                //                               child: Text(item),
                //                             ),
                //                             decoration: BoxDecoration(
                //                               border:
                //                                   Border.all(color: Colors.black),
                //                               borderRadius: BorderRadius.all(
                //                                 Radius.circular(10),
                //                               ),
                //                             ),
                //                           ),
                //                         )
                //                     ],
                //                   ),
                //                 ),
                //               SizedBox(height: 15),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     if (controller.isStateFilterClicked)
                //       Center(
                //         child: LocationSelectionCard(
                //           controller: controller,
                //           selectionListType: SelectionListType.STATE,
                //           isWeb: false,
                //         ),
                //       ),
                //     if (controller.isDistrictFilterClicked)
                //       Center(
                //         child: LocationSelectionCard(
                //           controller: controller,
                //           selectionListType: SelectionListType.DISTRICT,
                //           isWeb: false,
                //         ),
                //       ),
                //     if (controller.isParamsFilterClicked)
                //       Center(
                //         child: DownloadParamsSelectionCard(
                //           controller: controller,
                //           isWeb: false,
                //         ),
                //       ),
                //   ],
                // ),
                ),
          ),
  );
}
