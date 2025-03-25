import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imaginotes/core/entities/user_entity.dart';
import 'package:imaginotes/features/auth/domain/errors/sign_up_error.dart';

import '../../domain/errors/auth_error.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null ? true : false;
  }

  @override
  Future<Either<AuthError, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(
          AuthError(
            type: AuthErrorType.userNotFound,
            debugMessage: 'User not found',
          ),
        );
      }

      return Right(
        UserEntity(
          name: response.user!.displayName ?? '',
          uid: response.user!.uid,
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(
            AuthError(
              type: AuthErrorType.invalidEmail,
              debugMessage: e.toString(),
            ),
          );
        case 'user-disabled':
          return Left(
            AuthError(
              type: AuthErrorType.userDisabled,
              debugMessage: e.toString(),
            ),
          );
        case 'user-not-found':
          return Left(
            AuthError(
              type: AuthErrorType.userNotFound,
              debugMessage: e.toString(),
            ),
          );
        case 'wrong-password':
          return Left(
            AuthError(
              type: AuthErrorType.wrongPassword,
              debugMessage: e.toString(),
            ),
          );
        case 'too-many-requests':
          return Left(
            AuthError(
              type: AuthErrorType.tooManyRequests,
              debugMessage: e.toString(),
            ),
          );
        case 'user-token-expired':
          return Left(
            AuthError(
              type: AuthErrorType.userTokenExpired,
              debugMessage: e.toString(),
            ),
          );
        case 'network-request-failed':
          return Left(
            AuthError(
              type: AuthErrorType.networkRequestFailed,
              debugMessage: e.toString(),
            ),
          );
        case 'invalid-credential':
          return Left(
            AuthError(
              type: AuthErrorType.invalidLoginCredentials,
              debugMessage: e.toString(),
            ),
          );
        case 'operation-not-allowed':
          return Left(
            AuthError(
              type: AuthErrorType.operationNotAllowed,
              debugMessage: e.toString(),
            ),
          );
        default:
          return Left(
            AuthError(
              type: AuthErrorType.unknownError,
              debugMessage: e.toString(),
            ),
          );
      }
    } catch (e) {
      return Left(
        AuthError(type: AuthErrorType.unknownError, debugMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  @override
  Future<Either<SignUpError, UserEntity>> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(
        UserEntity(
          name: response.user!.displayName ?? '',
          uid: response.user!.uid,
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return Left(
            SignUpError(
              type: SignUpErrorType.emailAlreadyInUse,
              debugMessage: e.toString(),
            ),
          );
        case 'invalid-email':
          return Left(
            SignUpError(
              type: SignUpErrorType.invalidEmail,
              debugMessage: e.toString(),
            ),
          );
        case 'operation-not-allowed':
          return Left(
            SignUpError(
              type: SignUpErrorType.operationNotAllowed,
              debugMessage: e.toString(),
            ),
          );
        case 'weak-password':
          return Left(
            SignUpError(
              type: SignUpErrorType.weakPassword,
              debugMessage: e.toString(),
            ),
          );
        case 'too-many-requests':
          return Left(
            SignUpError(
              type: SignUpErrorType.tooManyRequests,
              debugMessage: e.toString(),
            ),
          );
        case 'user-token-expired':
          return Left(
            SignUpError(
              type: SignUpErrorType.userTokenExpired,
              debugMessage: e.toString(),
            ),
          );
        case 'network-request-failed':
          return Left(
            SignUpError(
              type: SignUpErrorType.networkRequestFailed,
              debugMessage: e.toString(),
            ),
          );
        default:
          return Left(
            SignUpError(
              type: SignUpErrorType.unknownError,
              debugMessage: e.toString(),
            ),
          );
      }
    } catch (e) {
      return Left(
        SignUpError(
          type: SignUpErrorType.unknownError,
          debugMessage: e.toString(),
        ),
      );
    }
  }
}
