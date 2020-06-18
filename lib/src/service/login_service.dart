import 'package:http/http.dart' as http;
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'dart:convert';


class LoginService{
  Future<UserModel> authUser(String username) async{
    UserModel userModel = new UserModel();
    userModel.username =username;
    final resp = await http.post(Constants.API_URL_LOGIN,body: userModelToJson(userModel).toString());

    print('LoginService...');
    print('resp.statusCode...' +resp.statusCode.toString());
    if(resp.statusCode != 200 && resp.statusCode != 201)
      throw Exception();

    Map userMap = jsonDecode(resp.body);
    var data = UserModel.fromJson(userMap);

    return data;
  }

}