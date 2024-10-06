import 'package:mongo_dart/mongo_dart.dart';
import 'package:vitron/variables.dart';

verify(email, password) async{
  var db = await Db.create(M_URL);
  await db.open();
  var users = db.collection("users");
  if (await users.findOne(where.eq("email", email).eq("password", password)) != null) {
    Email = email;
    return true;
  }
  else return false;
}

create(name, email, password) async{
  var db = await Db.create(M_URL);
  await db.open();
  var users = db.collection("users");
  if (await users.findOne(where.eq("email", email)) == null) {
    Email = email;
    await users.insertOne({"name":name,"email":email,"password":password});
    return true;
  }
  else return false;
}

addURL(IName, description) async {
  var db = await Db.create(M_URL);
  await db.open();
  DateTime n = DateTime.now();
  var history = db.collection("history");
  await history.insertOne({"email":Email,"description":description,"img":IName,"time":n.toString()});
}

getHistory() async{
  var db = await Db.create(M_URL);
  await db.open();
  var history = db.collection("history");
  return await history.find(where.eq("email", Email)).toList();
}

deleteHistory(id) async{
  var db = await Db.create(M_URL);
  await db.open();
  var history = db.collection("history");
  await history.deleteOne(where.eq("_id", id));
}