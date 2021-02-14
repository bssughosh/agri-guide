/// An exception which is thrown when a weak password is selected
/// while registering for the application
class RegisterWeakPasswordException implements Exception {}

/// An exception which is thrown when an email is already in use
/// is selected while registering for the application
class RegisterEmailAlreadyInUseException implements Exception {}

/// An exception which is thrown when
/// registering for the application
class RegisterGenericException implements Exception {}

/// An exception which is thrown when
/// logging in the application
class LoginGenericException implements Exception {}

/// An exception which is thrown when there are too many requests
/// while logging in the application
class LoginTooManyRequestException implements Exception {}

/// An exception which is thrown when there is a network error
/// while logging in the application
class LoginNetworkRequestFailedException implements Exception {}

/// An exception which is thrown when the login credentials are wrong
/// while logging in the application
class LoginInvalidCredentialsException implements Exception {}

/// An exception which is thrown when user is not signed
/// to view some content which needs authorization
class UserNotSignedInError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 400 Bad Request
class APIBadRequestError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 403 Forbidden
class APIForbiddenError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 404 Not Found
class APINotFoundError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 429 Too Many Requests
class APITooManyRequestsError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 500 Internal Server Error
class APIInternalServerError implements Exception {}

/// An exception which is thrown when the API returns an ERROR_CODE
/// of 503 Service Unavailable
class APIServiceUnavailabeError implements Exception {}

/// An exception which is thrown when the API returns a status apart from the
/// known ones
class APIGenericError implements Exception {}
