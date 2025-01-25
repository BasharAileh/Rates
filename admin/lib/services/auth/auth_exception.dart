//login exceptions
class InvalidEmailAuthException
    implements Exception {} //both login and register

class InvalidCredentialAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}

//verify email exceptions
class EmailNotVerifiedAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}
