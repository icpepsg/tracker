import 'dart:io';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/model/FbModel.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'dart:convert';


class LoginService{
  static final FacebookLogin facebookSignIn = new FacebookLogin();



  Future<UserModel> authUser(String username,String password) async{
    UserModel userModel = new UserModel();
    userModel.username =username;
    userModel.password =password;
    final resp = await http.post(Constants.API_URL_LOGIN,headers: {"Content-Type": "application/json"},body: userModelToJson(userModel));
    print('LoginService...');
    print('resp.statusCode...' +resp.statusCode.toString());
    //if(resp.statusCode != 200 && resp.statusCode != 201)
    // throw Exception();
    Map userMap = jsonDecode(resp.body);
    var data = UserModel.fromJson(userMap);

    return data;
  }

  Future<FbModel> authFB() async {
   // facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    facebookSignIn.loginBehavior = Platform.isIOS
        ? FacebookLoginBehavior.webViewOnly
        : FacebookLoginBehavior.nativeWithFallback;
    FbModel fbModel = new FbModel();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    print('Token: ${result.accessToken.token}');
    print('User id: ${result.accessToken.userId}');
    print('Expires: ${result.accessToken.expires}');
    print('Permissions: ${result.accessToken.permissions}');
    print('Declined permissions: ${result.accessToken.declinedPermissions}');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResp = await http.get(Constants.API_URL_FACEBOOK_TOKEN + token);
        if (result.status == FacebookLoginStatus.loggedIn) {
          Map resp = jsonDecode(graphResp.body);
          var data = FbModel.fromJson(resp);
          fbModel =data;
        }
        print('loggedIn');
        return fbModel;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelledByUser');
        return fbModel;
      case FacebookLoginStatus.error:
        print('error : ' + result.errorMessage);
        await facebookSignIn.logOut();
        print('logOut : ');
        return fbModel;
    }
  }

}