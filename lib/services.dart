import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:vitron/database.dart';
import 'package:vitron/main.dart';
import 'package:vitron/storage.dart';
import 'package:vitron/variables.dart';

showMessage(context, message) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Ok"))
      ],
    );
  });
}

signup(context, name,email, password) async{
  if(await create(name, email, password) == false) showMessage(context, "Account already exists");
  else {
    showMessage(context, "Account successfully created");
    await setAccDetails(email, password);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
  }
}

signin(context, email, password) async{
  if(await verify(email, password) == false) showMessage(context, "Wrong credentials");
  else {
    showMessage(context, "Account successfully");
    await setAccDetails(email, password);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
  }
}

logout(context) async {
  clearDetails();
  Email=null;
}

VerifySession(context) async{
  var session = await getAccDetails();
  return await verify(session["email"], session["password"]);
}

getresponse(description) async {
  var rt = await http.post(
    Uri.parse(server),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body : {
      "data":data,
    },
  );
  if (await rt.statusCode == 200) {
    if (Email != null && Email != Null) {
      await addURL(rt.body,description);
    }
    ImageURL = rt.body;
  }
}

HistoryCard(context, inf) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          blurRadius: 10,
          blurStyle: BlurStyle.outer
        )],
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(S_Server+inf["img"]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(inf["time"].toString().split(".")[0]),
                IconButton(onPressed: () {
                  deleteHistory(inf["_id"]);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
                }, icon: Icon(Icons.delete))
              ],
            ),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ViewImage(image:S_Server+inf["img"]);
              }));
            }, child: Text("View image"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
          ],
        ),
      ),
    ),
  );
}

class ViewImage extends StatelessWidget {
  final String image;
  const ViewImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
              }, icon: Icon(Icons.arrow_back)),
              SizedBox(width: 10,),
              Text("History")
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height*0.7,
                child: PhotoView(imageProvider: NetworkImage(image))
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () {
                  copy() async{
                    await Clipboard.setData(ClipboardData(text: S_Server+ImageURL));
                  }
                  copy();
                  showMessage(context, "Copied to clipboard");
              }, child: Text("Copy image url"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}