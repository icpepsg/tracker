import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'package:tracker/src/service/login_service.dart';


class LoginEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class AuthLogin extends LoginEvent{
  final _username;
  final _password;
  AuthLogin(this._username,this._password);

  @override
  List<Object> get props => [_username,_password];
}


class LoginState extends Equatable{
  @override
  List<Object> get props => [];

}


class LoginInit extends LoginState{
}

class LoginIsLoading extends LoginState{
}

class LoginIsLoaded extends LoginState{
  final _credential;
  LoginIsLoaded(this._credential);
  UserModel get getCredential => _credential;
  @override
  List<Object> get props => [_credential];
}

class LoginError extends LoginState{
  final _message;
  LoginError(this._message);
  String get getMessage => _message;
  @override
  List<Object> get props => [_message];
}

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  LoginService loginService;

  LoginBloc(this.loginService);

  @override
  LoginState get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{

    if(event is AuthLogin){
      yield LoginIsLoading();
      try{
        UserModel userData = await loginService.authUser(event._username,event._password);
        print(userData);
        print('userData.success '+userData.success.toString());
        if(userData.success){
          print('Authentication Success...');
          yield LoginIsLoaded(userData);
        }else{
          print('Authentication error...');
          yield LoginError(userData.message);
        }

      }catch(_){
        print('Authentication Exception!!');
        yield LoginInit();
      }
    }
  }

}