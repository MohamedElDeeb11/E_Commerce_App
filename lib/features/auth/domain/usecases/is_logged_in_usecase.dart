import 'package:t_store/core/dependency_injection/get_it.dart.dart';
import 'package:t_store/core/usecase/usecase.dart';
import 'package:t_store/features/auth/domain/repository/auth_repo.dart';

class IsLoggedInUsecase extends UseCase<bool, NoParams> {
  @override
  Future<bool> call({NoParams? param}) async {
    return await sl<AuthRepo>().isLoggedIn();
  }
}
