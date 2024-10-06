import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var localStorage = new FlutterSecureStorage();

setAccDetails(email, password) async{
  await localStorage.write(key: "email", value: email);
  await localStorage.write(key: "password", value: password);
  return true;
}

getAccDetails() async{
  if (await localStorage.read(key: "email") != null) {
    var e = await localStorage.read(key: "email");
    var p = await localStorage.read(key: "password");
    return {"email":e,"password":p};
  } else {
    return null;
  }
}

clearDetails() async {
  localStorage.deleteAll();
}