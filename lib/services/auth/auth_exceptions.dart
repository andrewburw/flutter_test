// login exeptions
class UserNotFoundAuthException implements Exception {}
class WrongPasswordFoundAuthException implements Exception {}

// register exeptions

class WeakPasswordFoundAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class InvalidEmailUseAuthException implements Exception {}

//generc exceptions

class GenericAuthException implements Exception {}
class UserNotLoggedInAuthException implements Exception {}