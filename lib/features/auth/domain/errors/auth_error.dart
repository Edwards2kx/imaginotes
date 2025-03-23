enum AuthErrorType {
  invalidEmail('Email invalido'),
  userDisabled('Usuario deshabilitado'),
  userNotFound('Usuario no encontrado'),
  wrongPassword('Contraseña incorrecta'),
  tooManyRequests('Demasiadas solicitudes'),
  userTokenExpired('Token de usuario caducado'),
  networkRequestFailed('Error de solicitud de red'),
  invalidLoginCredentials('Credenciales de inicio de sesión no válidas'),
  operationNotAllowed('Operación no permitida'),
  unknownError('Sucedio algo inexperado, intenta de nuevo');

  final String description;
  const AuthErrorType(this.description);
}

class AuthError {
  final AuthErrorType type;
  final String debugMessage;

  AuthError({required this.type, required this.debugMessage});
}
