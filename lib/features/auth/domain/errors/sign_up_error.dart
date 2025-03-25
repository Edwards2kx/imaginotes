enum SignUpErrorType {
  emailAlreadyInUse('El email ya esta en uso'),
  invalidEmail('email invalido'),
  operationNotAllowed('operacion no permitida'),
  weakPassword('contraseña muy débil'),
  tooManyRequests('demasiadas solicitudes'),
  userTokenExpired('token de usuario caducado'),
  networkRequestFailed('error de solicitud de red'),
  unknownError('sucedio algo inexperado, intenta de nuevo');

  final String description;
  const SignUpErrorType(this.description);
}

class SignUpError {
  final SignUpErrorType type;
  final String debugMessage;

  SignUpError({required this.type, required this.debugMessage});
}
