import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart';
import 'package:vitron/database.dart';
import 'package:vitron/storage.dart';
import 'package:vitron/services.dart';
import 'package:vitron/variables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Index(),
    );
  }
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    var tbx = new TextEditingController();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Vitron"),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return History();
                }));
              }, icon: Icon(Icons.history))
            ],
          )
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height*0.6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tbx,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter your medicine prescription",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(style: BorderStyle.solid)
                        )
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      if (tbx.text.length > 10) {
                        data = tbx.text;
                        description = tbx.text;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return Result();
                        }));
                      } else {
                        showMessage(context, "Write appropiate information");
                      }
                    }, child: Text("Get details"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool Loading = true;

  Future getResponse() async {
    await getresponse(description);
    print(ImageURL);
    setState(() {
      Loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponse();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){ return Index();}));
              }, icon: Icon(Icons.arrow_back)),
              SizedBox(width: 10,),
              Text("Result")
            ],
          ),
        ),
        body: Loading ? Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Text("Converting data", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          ),
        ) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 300,
                  child: PhotoView(imageProvider: NetworkImage(S_Server+ImageURL))
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: () {
                  copy() async{
                    await Clipboard.setData(ClipboardData(text: S_Server+ImageURL));
                  }
                  copy();
                  showMessage(context, "Copied to clipboard");
                }, child: Text("Copy shareble link"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool Loading = true;
  var HistoryData;

  getAccountDetails() async{
    var gcd = await getAccDetails();
    if (gcd == null) setState(() {
      data = null;
      Loading = false;
    });
    if (gcd != null) {
      data = gcd;
      if (await VerifySession(context) == true) {
        HistoryData = await getHistory();
        setState(() {
          Loading = false;
        });
      } else {
        clearDetails();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: (Email != null && Email != Null) ? FloatingActionButton(onPressed: () {
          logout(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
        }, child: Icon(Icons.logout), backgroundColor: Colors.black, foregroundColor: Colors.white,) : null,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Index();
                }));
              }, icon: Icon(Icons.arrow_back)),
              SizedBox(width: 10,),
              Text("Your profile"),
            ],
          ),
        ),
        body:Loading ? Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Text("Loading content", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          ),
        ) : data == null ? Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: MediaQuery.sizeOf(context).width*0.8,child: ElevatedButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignUp();}));
              }, child: Text("Sign Up"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)),
              SizedBox(width: MediaQuery.sizeOf(context).width*0.8,child: ElevatedButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Login();}));
              }, child: Text("Sign In"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)),
            ],
          )),
        ) : (HistoryData.length == 0) ? Container(width: MediaQuery.sizeOf(context).width,child: Center(child: Text("No history" ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))) :  SingleChildScrollView(
          child: Column(
            children: [
              for (var i in HistoryData) HistoryCard(context, i)
            ],
          ),
        ),
      ),
    );
  }
}
class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = new TextEditingController();
    TextEditingController password = new TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[700],
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.sizeOf(context).width*0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Login", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(onPressed: () {
                      signin(context, email.text, password.text);
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white) ,child: Text("Login")),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
                        }, child: Text("Home?", style: TextStyle(color: Colors.indigo[700]))),
                        TextButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignUp();}));
                        }, child: Text("Sign Up?", style: TextStyle(color: Colors.indigo[700]))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class SignUp extends StatelessWidget {
  SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
    TextEditingController email = new TextEditingController();
    TextEditingController password = new TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[700],
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.sizeOf(context).width*0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sign Up", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(onPressed: () {
                      signup(context, name.text, email.text, password.text);
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white) ,child: Text("Sign Up")),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {return History();}));
                        }, child: Text("Home?", style: TextStyle(color: Colors.indigo[700]))),
                        TextButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Login();}));
                        }, child: Text("Sign In?", style: TextStyle(color: Colors.indigo[700]))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
