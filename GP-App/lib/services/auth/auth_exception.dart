//login exceptions
class InvalidEmailAuthException
    implements Exception {} //both login and register

class InvalidCredentialAuthException implements Exception {}

//register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
