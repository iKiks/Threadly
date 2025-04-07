import 'package:fpdart/fpdart.dart';
import 'package:threadly/core/common/entities/user.dart';
import 'package:threadly/core/error/failures.dart';
import 'package:threadly/core/usecase/usecase.dart';
import 'package:threadly/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) {
    return authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
