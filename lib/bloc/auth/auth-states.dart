import '/model/login-response.dart';
import '/model/user.dart';

abstract class AuthStates {}

class AuthStateLoading extends AuthStates {
  AuthStateLoading();
}

class AccountsLoaded extends AuthStates {
  final UserInfo user;
  List<UserInfo> users;

  AccountsLoaded({this.user, this.users});
}

class AccountsNotLoaded extends AuthStates {
  AccountsNotLoaded();
}

class LoginSuccess extends AuthStates {
  final LoginResponse loginResponse;
  LoginSuccess(this.loginResponse);
}

class LoginFailed extends AuthStates {
  LoginFailed();
}

class OtpNotVerified extends AuthStates {}

class OtpVerified extends AuthStates {}
