import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cwdapp/ML/recognitions.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Recognizer {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  // final dbHelper = DatabaseHelper();
  List<Recognition> registered = [];
  @override
  String get modelName => 'assets/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    loadRegisteredFaces();
    // initDB();
  }

  // initDB() async {
  //   await dbHelper.init();
  //   loadRegisteredFaces();
  // }

  void loadRegisteredFaces() async {
    // final allRows = await dbHelper.queryAllRows();
    // debugPrint('query all rows:');
    // for (final row in allRows) {
    //  debugPrint(row.toString());
    //   print(row[DatabaseHelper.columnName]);
    //   String name = row[DatabaseHelper.columnName];
    //   List<double> embd = row[DatabaseHelper.columnEmbedding].split(',').map((e) => double.parse(e)).toList().cast<double>();
    //   Recognition recognition = Recognition(row[DatabaseHelper.columnName],Rect.zero,embd,0);
    //   registered.putIfAbsent(name, () => recognition);
    // }
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("people").get();
    for (var id in data.docs) {
      Map<String, dynamic> people = id.data() as Map<String, dynamic>;
      String name = people['name'];
      List<double> embd = people['embedding']
          .split(',')
          .map((e) => double.parse(e))
          .toList()
          .cast<double>();
      Recognition recognition =
          Recognition(name, Rect.zero, embd, 0, people['sid']);
      registered.add(recognition);
    }
  }

  void registerFaceInDB(String name, int sid, List<double> embedding) async {
    // row to insert
    // Map<String, dynamic> row = {
    //   DatabaseHelper.columnName: name,
    //   DatabaseHelper.columnEmbedding: embedding.join(",")
    // };
    // final id = await dbHelper.insert(row);
    // print('inserted row id: $id');
    try {
      await firestore
          .collection('people')
          .add({'name': name, 'sid': sid, 'embedding': embedding.join(',')});
    } catch (e) {
      //   print(e);
    }
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      // print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  Recognition recognize(img.Image image, Rect location) {
    // crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    // print(input.shape.toString());

    // output array
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    // performs inference
    // final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    // final run = DateTime.now().millisecondsSinceEpoch - runs;
    // print('Time to run inference: $run ms$output');

    // convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    // looks for the nearest embeeding in the database and returns the pair
    Pair pair = findNearest(outputArray);
    if (pair.distance < 1.25) {}
    // print("distance= ${pair.distance}");

    return Recognition(pair.distance < 1.25 ? pair.name : "UNKNOWN FACE",
        location, outputArray, pair.distance, pair.SID);
  }

  // looks for the nearest embeeding in the database
  // and returns the pair which contain information of registered face with which face is most similar

  findNearest(List<double> emb) {
    Pair pair = Pair("Unknown", -5, 00000);
    for (Recognition item in registered) {
      final String name = item.name;
      final int SID = item.SID;
      List<double> knownEmb = item.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
        pair.SID = SID;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;
  int SID;
  Pair(this.name, this.distance, this.SID);
}
