import 'package:fpdart/fpdart.dart';
import 'package:threadly/core/common/entities/user.dart';
import 'package:threadly/core/error/exceptions.dart';
import 'package:threadly/core/error/failures.dart';
import 'package:threadly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:threadly/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      final user = await _remoteDataSource.getCurrentUserData();
      if (user == null) {
        return Left(Failure("User not found after login"));
      }
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
