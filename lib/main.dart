import 'dart:io';

import 'package:flutter/material.dart';

import 'diseases_predictor.dart';

import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DiseasePredictor.loadModel(); // Load TFLite model
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DiseasePredictionScreen(),
    );
  }
}

class DiseasePredictionScreen extends StatefulWidget {
  const DiseasePredictionScreen({super.key});

  @override
  State<DiseasePredictionScreen> createState() =>
      _DiseasePredictionScreenState();
}

class _DiseasePredictionScreenState extends State<DiseasePredictionScreen> {
  String? _predictionResult;
  String? _imagePath;

  Future<void> _pickImageAndPredict() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
        _predictionResult = "Predicting...";
      });
      try {
        await DiseasePredictor.predict(pickedImage.path);
      } catch (e) {
        print("Error while getting prediction  $e");
      }



      // You can optionally store and show the prediction
      // For now, we just print in the console as defined in DiseasePredictor
    } else {
      setState(() {
        _predictionResult = "No image selected.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Disease Predictor")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagePath != null)
              Image.file(File(_imagePath!), width: 200, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageAndPredict,
              child: const Text("Pick Image & Predict"),
            ),
            const SizedBox(height: 20),
            if (_predictionResult != null) Text(_predictionResult!),
          ],
        ),
      ),
    );
  }
}
