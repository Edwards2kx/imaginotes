import 'package:either_dart/either.dart';
import 'package:imaginotes/core/entities/user_entity.dart';
import 'package:imaginotes/features/auth/domain/errors/auth_error.dart';
import 'package:imaginotes/features/auth/domain/errors/sign_up_error.dart';

abstract class AuthRepository {
  Future<Either<AuthError, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
  Future<bool> isSignedIn();

  Future<Either<SignUpError, UserEntity>> registerWithEmailAndPassword(
    String email,
    String password,
  );
}
