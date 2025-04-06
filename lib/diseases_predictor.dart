import 'package:tflite_v2/tflite_v2.dart';

class DiseasePredictor {
  /// Loads the TFLite model and labels
  static Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print("✅ Model loaded: $res");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  /// Takes image path and prints prediction result
  static Future<void> predict(String imagePath) async {
    try {
      final results = await Tflite.runModelOnImage(
        path: imagePath,
        numResults: 2,            // ✅ Set to match your model's 2 output classes
        threshold: 0.5,
        imageMean: 0.0,           // Your model is scaled to [0, 1] (rescale=1./255)
        imageStd: 1.0,            // Updated from 255.0 to 1.0 for proper normalization
      );

      if (results != null && results.isNotEmpty) {
        print("🧾 Prediction Result:");
        for (var result in results) {
          print("🔹 ${result['label']} - ${(result['confidence'] * 100).toStringAsFixed(2)}%");
        }
      } else {
        print("❌ No prediction results.");
      }
    } catch (e) {
      print("❌ Error during prediction: $e");
    }
  }

  /// Optional: Close the model when done
  static Future<void> disposeModel() async {
    await Tflite.close();
  }
}
