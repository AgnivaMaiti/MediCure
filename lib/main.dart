import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart';
import 'package:vitron/database.dart';
import 'package:vitron/storage.dart';
import 'package:vitron/services.dart';
import 'package:vitron/variables.dart';
import 'package:vitron/food_analysis.dart';

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
            Text("MediCure"),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FoodAnalysis();
                    }));
                  },
                  icon: Icon(Icons.restaurant),
                  tooltip: "Food Analysis",
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return History();
                      }));
                    },
                    icon: Icon(Icons.history))
              ],
            ),
          ],
        )),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo/Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 60,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "MediCure",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Personal Health Companion",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Medicine Analysis Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.description,
                            size: 40, color: Colors.blue[700]),
                        SizedBox(height: 15),
                        Text(
                          "Medicine Prescription Analysis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: tbx,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                "Enter your medicine prescription details...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue[600]!, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (tbx.text.length > 10) {
                                data = tbx.text;
                                description = tbx.text;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return Result();
                                }));
                              } else {
                                showMessage(context, "Please enter more details about your prescription");
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Analyze Prescription",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Food Analysis Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return FoodAnalysis();
                        }));
                      },
                      icon: Icon(Icons.restaurant),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Analyze Food",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
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
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Index();
                    }));
                  },
                  icon: Icon(Icons.arrow_back)),
              SizedBox(
                width: 10,
              ),
              Text("Result")
            ],
          ),
        ),
        body: Loading
            ? Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Text(
                    "Converting data",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 300,
                          child: PhotoView(
                              imageProvider:
                                  NetworkImage(S_Server + ImageURL))),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          copy() async {
                            await Clipboard.setData(
                                ClipboardData(text: S_Server + ImageURL));
                          }

                          copy();
                          showMessage(context, "Copied to clipboard");
                        },
                        child: Text("Copy shareble link"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                      )
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

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  bool Loading = true;
  var HistoryData;
  var FoodHistoryData;
  var MedicalConsultationData;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getAccountDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getAccountDetails() async {
    var gcd = await getAccDetails();
    if (gcd == null)
      setState(() {
        data = null;
        Loading = false;
      });
    if (gcd != null) {
      data = gcd;
      if (await VerifySession(context) == true) {
        HistoryData = await getHistory();
        FoodHistoryData = await getFoodHistory();
        MedicalConsultationData = await getMedicalConsultations();
        setState(() {
          Loading = false;
        });
      } else {
        clearDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: (Email != null && Email != Null)
            ? FloatingActionButton(
                onPressed: () {
                  logout(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return History();
                  }));
                },
                child: Icon(Icons.logout),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              )
            : null,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Index();
                    }));
                  },
                  icon: Icon(Icons.arrow_back)),
              SizedBox(
                width: 10,
              ),
              Text("Your profile"),
            ],
          ),
          bottom: (data != null)
              ? TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                        text: "Prescriptions",
                        icon: Icon(Icons.medical_services)),
                    Tab(text: "Food Analysis", icon: Icon(Icons.restaurant)),
                    Tab(text: "Consultations", icon: Icon(Icons.psychology)),
                  ],
                )
              : null,
        ),
        body: Loading
            ? Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Text(
                    "Loading content",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : data == null
                ? Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_circle,
                            size: 100, color: Colors.grey),
                        SizedBox(height: 20),
                        Text("Sign in to access your history",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700])),
                        SizedBox(height: 30),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SignUp();
                                }));
                              },
                              child: Text("Sign Up"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white),
                            )),
                        SizedBox(height: 10),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return Login();
                                }));
                              },
                              child: Text("Sign In"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white),
                            )),
                      ],
                    )),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Prescription History Tab
                      (HistoryData.length == 0)
                          ? Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.history,
                                        size: 80, color: Colors.grey),
                                    SizedBox(height: 20),
                                    Text("No prescription history",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i in HistoryData)
                                    HistoryCard(context, i)
                                ],
                              ),
                            ),

                      // Food History Tab
                      (FoodHistoryData.length == 0)
                          ? Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.restaurant,
                                        size: 80, color: Colors.grey),
                                    SizedBox(height: 20),
                                    Text("No food analysis history",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i in FoodHistoryData)
                                    FoodHistoryCard(context, i)
                                ],
                              ),
                            ),

                      // Medical Consultation History Tab
                      (MedicalConsultationData?.length == 0)
                          ? Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.psychology, size: 80, color: Colors.grey),
                                    SizedBox(height: 20),
                                    Text("No medical consultation history",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i in MedicalConsultationData ?? [])
                                    MedicalConsultationCard(context, i)
                                ],
                              ),
                            ),
                    ],
                  ),
      ),
    );
  }
}

// New widget for food history cards
Widget FoodHistoryCard(context, inf) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            blurStyle: BlurStyle.outer,
            color: Colors.grey.withOpacity(0.3),
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.restaurant, color: Colors.green),
                    SizedBox(width: 10),
                    Text("Food Analysis",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    deleteFoodHistory(inf["_id"]);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return History();
                    }));
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              inf["time"].toString().split(".")[0],
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return FoodAnalysisResult(
                      analysisResult: inf["analysis_result"]);
                }));
              },
              child: Text("View Analysis"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// New widget for medical consultation history cards
Widget MedicalConsultationCard(context, inf) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            blurStyle: BlurStyle.outer,
            color: Colors.grey.withOpacity(0.3),
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.purple),
                    SizedBox(width: 10),
                    Text("Medical Consultation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    deleteMedicalConsultation(inf["_id"]);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return History();
                    }));
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              inf["time"].toString().split(".")[0],
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              inf["medical_advice"].toString().substring(0, 
                inf["medical_advice"].toString().length > 100 ? 100 : inf["medical_advice"].toString().length) + "...",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Medical Consultation"),
                    content: SingleChildScrollView(
                      child: Text(inf["medical_advice"]),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("View Full Consultation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[700],
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          signin(context, email.text, password.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: const Text("Login")),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const History();
                              }));
                            },
                            child: Text("Home?",
                                style: TextStyle(color: Colors.indigo[700]))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return SignUp();
                              }));
                            },
                            child: Text("Sign Up?",
                                style: TextStyle(color: Colors.indigo[700]))),
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
  const SignUp({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[700],
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          signup(context, name.text, email.text, password.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: const Text("Sign Up")),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const History();
                              }));
                            },
                            child: Text("Home?",
                                style: TextStyle(color: Colors.indigo[700]))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                            },
                            child: Text("Sign In?",
                                style: TextStyle(color: Colors.indigo[700]))),
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
