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

// New function for food analysis history
addFoodAnalysis(analysisResult, description) async {
  var db = await Db.create(M_URL);
  await db.open();
  DateTime n = DateTime.now();
  var foodHistory = db.collection("food_history");
  await foodHistory.insertOne({
    "email": Email,
    "description": description,
    "analysis_result": analysisResult,
    "time": n.toString(),
    "type": "food_analysis"
  });
}

// New function for medical consultation history
addMedicalConsultation(foodAnalysis, prescriptionData, medicalAdvice) async {
  var db = await Db.create(M_URL);
  await db.open();
  DateTime n = DateTime.now();
  var consultationHistory = db.collection("medical_consultations");
  await consultationHistory.insertOne({
    "email": Email,
    "food_analysis": foodAnalysis,
    "prescription_data": prescriptionData,
    "medical_advice": medicalAdvice,
    "time": n.toString(),
    "type": "medical_consultation"
  });
}

getHistory() async{
  var db = await Db.create(M_URL);
  await db.open();
  var history = db.collection("history");
  return await history.find(where.eq("email", Email)).toList();
}

// New function to get food analysis history
getFoodHistory() async{
  var db = await Db.create(M_URL);
  await db.open();
  var foodHistory = db.collection("food_history");
  return await foodHistory.find(where.eq("email", Email)).toList();
}

// Get medical consultation history
getMedicalConsultations() async{
  var db = await Db.create(M_URL);
  await db.open();
  var consultationHistory = db.collection("medical_consultations");
  return await consultationHistory.find(where.eq("email", Email)).toList();
}

deleteHistory(id) async{
  var db = await Db.create(M_URL);
  await db.open();
  var history = db.collection("history");
  await history.deleteOne(where.eq("_id", id));
}

// New function to delete food analysis history
deleteFoodHistory(id) async{
  var db = await Db.create(M_URL);
  await db.open();
  var foodHistory = db.collection("food_history");
  await foodHistory.deleteOne(where.eq("_id", id));
}

// Delete medical consultation
deleteMedicalConsultation(id) async{
  var db = await Db.create(M_URL);
  await db.open();
  var consultationHistory = db.collection("medical_consultations");
  await consultationHistory.deleteOne(where.eq("_id", id));
}