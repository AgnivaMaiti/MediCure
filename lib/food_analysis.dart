import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vitron/services.dart';
import 'package:vitron/variables.dart';
import 'package:vitron/database.dart';

class FoodAnalysis extends StatelessWidget {
  const FoodAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
              Text('Food Analyzer'),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Analyze Your Food',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Upload an image to get nutritional information',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    _uploadImage(context);
                  },
                  icon: Icon(Icons.upload),
                  label: Text('Upload Food Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage(BuildContext context) async {
    final picker = ImagePicker();
    
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        // Validate file size (e.g., max 5MB)
        File imageFile = File(pickedFile.path);
        int fileSizeInBytes = await imageFile.length();
        if (fileSizeInBytes > 5 * 1024 * 1024) {
          showMessage(context, "Image too large. Please select a smaller image.");
          return;
        }
        
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Analyzing food..."),
              ],
            ),
          ),
        );

        try {
          var request = http.MultipartRequest(
            'POST', 
            Uri.parse('${server}') // Changed from '${server}analyze_food' to just '${server}'
          );
          request.files.add(
            await http.MultipartFile.fromPath('file', imageFile.path)
          );
          
          var response = await request.send();
          Navigator.of(context).pop(); // Close loading dialog
          
          if (response.statusCode == 200) {
            String responseBody = await response.stream.bytesToString();
            
            // Save to history if user is logged in
            if (Email != null) {
              await addFoodAnalysis(responseBody, "Food analysis");
            }
            
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodAnalysisResult(
                  analysisResult: responseBody,
                ),
              ),
            );
          } else {
            showMessage(context, "Failed to analyze food. Please try again.");
          }
        } catch (e) {
          Navigator.of(context).pop(); // Close loading dialog
          showMessage(context, "Network error. Please check your connection.");
        }
      }
    } catch (e) {
      showMessage(context, "Error selecting image: ${e.toString()}");
    }
  }
}

class FoodAnalysisResult extends StatelessWidget {
  final String analysisResult;

  const FoodAnalysisResult({super.key, required this.analysisResult});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> result;

    try {
      result = jsonDecode(analysisResult);
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text('Error parsing analysis result'),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
              Text('Food Analysis Result'),
            ],
          ),
        ),
        body: result["food"] == "no"
            ? Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_food, size: 80, color: Colors.orange),
                      SizedBox(height: 20),
                      Text(
                        "No food detected",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please try uploading a clearer image of food",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nutritional Overview Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildNutritionCard(
                              "Calories",
                              result["calories"]?.toString() ?? "0",
                              "kcal",
                              Colors.red,
                              Icons.local_fire_department,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildNutritionCard(
                              "Sugar",
                              result["sugar"]?.toString() ?? "0",
                              "g",
                              Colors.orange,
                              Icons.cake,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // NEW: Medical Consultation Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MedicalConsultation(
                                  foodAnalysis: result,
                                  originalAnalysisResult: analysisResult,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.medical_services),
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Get Medical Consultation",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Ingredients Section
                      if (result["ingredients"] != null) ...[
                        _buildSectionTitle("Ingredients", Icons.list),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var ingredient in result["ingredients"])
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Icon(Icons.fiber_manual_record,
                                          size: 8, color: Colors.green),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          ingredient.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],

                      // Nutrients Section
                      if (result["nutrients"] != null) ...[
                        _buildSectionTitle(
                            "Detailed Nutrients", Icons.analytics),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (var nutrient in result["nutrients"])
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        nutrient["name"]?.toString() ??
                                            "Unknown",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          "${nutrient["weight"]?.toString() ?? "0"}g",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildNutritionCard(
      String title, String value, String unit, Color color, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              "$value $unit",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

// NEW: Medical Consultation Screen
class MedicalConsultation extends StatefulWidget {
  final Map<String, dynamic> foodAnalysis;
  final String originalAnalysisResult;

  const MedicalConsultation({
    super.key,
    required this.foodAnalysis,
    required this.originalAnalysisResult,
  });

  @override
  State<MedicalConsultation> createState() => _MedicalConsultationState();
}

class _MedicalConsultationState extends State<MedicalConsultation> {
  final TextEditingController _prescriptionController = TextEditingController();
  bool _isAnalyzing = false;
  String? _medicalAdvice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Consultation'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Summary Card
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
                    Icon(Icons.restaurant, size: 40, color: Colors.blue[700]),
                    SizedBox(height: 10),
                    Text(
                      "Food Analysis Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickStat("Calories", 
                            "${widget.foodAnalysis['calories'] ?? '0'} kcal"),
                        _buildQuickStat("Sugar", 
                            "${widget.foodAnalysis['sugar'] ?? '0'} g"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Prescription Input
              Text(
                "Enter Your Medical Prescription/Health Conditions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _prescriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Enter your current medications, health conditions, allergies, or dietary restrictions...\n\nExample:\n- Diabetes medication (Metformin)\n- High blood pressure\n- Allergic to nuts\n- Low sodium diet recommended",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.purple[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.purple[600]!, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Analyze Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeFoodWithPrescription,
                  icon: _isAnalyzing 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.analytics),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      _isAnalyzing ? "Analyzing..." : "Get Medical Advice",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Medical Advice Results
              if (_medicalAdvice != null) ...[
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.medical_services, 
                              color: Colors.green[700], size: 30),
                          SizedBox(width: 10),
                          Text(
                            "Medical Recommendation",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        _medicalAdvice!,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, 
                                color: Colors.orange[800], size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "This is AI-generated advice. Always consult your doctor for medical decisions.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _analyzeFoodWithPrescription() async {
    if (_prescriptionController.text.trim().isEmpty) {
      showMessage(context, "Please enter your prescription or health conditions");
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Prepare the combined data for analysis
      String combinedAnalysis = """
Food Analysis Data: ${widget.originalAnalysisResult}

Medical Information: ${_prescriptionController.text}

Please analyze if this food is suitable for the person based on their medical conditions and provide detailed recommendations.
""";

      // Send to server for medical analysis
      var response = await http.post(
        Uri.parse('${server}medical_consultation'), // New endpoint
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "food_data": widget.originalAnalysisResult,
          "prescription_data": _prescriptionController.text,
          "analysis_type": "medical_consultation"
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _medicalAdvice = response.body;
          _isAnalyzing = false;
        });

        // Save the consultation to history
        if (Email != null) {
          await addMedicalConsultation(
            widget.originalAnalysisResult,
            _prescriptionController.text,
            response.body,
          );
        }
      } else {
        setState(() {
          _isAnalyzing = false;
        });
        showMessage(context, "Failed to get medical consultation. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      showMessage(context, "Network error. Please check your connection.");
    }
  }
}
