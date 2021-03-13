import 'package:fluttertoast/fluttertoast.dart';

import 'exceptions.dart';

handleAPIErrors(Exception error) {
  if (error.runtimeType == APIBadRequestError) {
    Fluttertoast.showToast(
        msg: 'A bad request was encountered. Please try again');
  } else if (error.runtimeType == APIForbiddenError) {
    Fluttertoast.showToast(msg: 'The request was forbidden. Please try again');
  } else if (error.runtimeType == APINotFoundError) {
    Fluttertoast.showToast(
        msg:
            'The request was incorrect. Please check the request and try again');
  } else if (error.runtimeType == APITooManyRequestsError) {
    Fluttertoast.showToast(
        msg:
            'There are too many requests serviced right now. Please try again after sometime');
  } else if (error.runtimeType == APIInternalServerError) {
    Fluttertoast.showToast(
        msg:
            'There was an internal server error. Please try again after sometime');
  } else if (error.runtimeType == APIServiceUnavailabeError) {
    Fluttertoast.showToast(
        msg:
            'The server is under maintenance right now. Please try again after sometime');
  } else {
    Fluttertoast.showToast(
        msg:
            'The request was incorrect. Please check the request and try again');
  }
}
