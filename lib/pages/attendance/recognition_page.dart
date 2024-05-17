import 'dart:io';
import 'package:cwdapp/ML/Recognizer.dart';
import 'package:cwdapp/ML/recognitions.dart';
import 'package:cwdapp/secret.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:gsheets/gsheets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RecognitionScreen> {
  // declare variables
  late ImagePicker imagePicker;
  File? _image;

  // declare detector
  late FaceDetector faceDetector;

  // declare face recognizer
  late Recognizer recognizer;
  late Worksheet? sheet;
  late Spreadsheet ss;
  late GSheets gsheets;
  List<int> SIDs = [];
  @override
  void initState() {
    _loadCredential();
    // : implement initState
    super.initState();
    imagePicker = ImagePicker();

    // initialize face detector
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    // initialize face recognizer
    recognizer = Recognizer();
  }

  _loadCredential() async {
    // print("load creds started");
    DateTime today = DateTime.now();
    gsheets = GSheets(Secret.credentials);
    ss = await gsheets.spreadsheet(Secret.spreadsheetId);
    sheet = ss.worksheetByTitle('Sheet1');
    // print('Google Sheet Successfully Load');
    // print(sheet);
    var data = await sheet!.values.allRows();
    for (int i = 1; i < data.length; i++) {
      DateTime dateTime = DateTime(1899, 12, 30)
          .add(Duration(days: double.parse(data[i][0]).round()));
      if (dateTime.day == today.day &&
          dateTime.month == today.month &&
          dateTime.year == today.year) {
        SIDs.add(int.parse(data[i][2]));
      }
    }
  }

  // capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  // choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  // face detection code here
  List<Face> faces = [];
  doFaceDetection() async {
    recognitions.clear();
    // remove rotation of camera images
    _image = await removeRotation(_image!);

    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    // passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left < 0 ? 0 : faceRect.left;
      num top = faceRect.top < 0 ? 0 : faceRect.top;
      num right =
          faceRect.right > image.width ? image.width - 1 : faceRect.right;
      num bottom =
          faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      // crop face
      final bytes = _image!
          .readAsBytesSync(); //await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image faceImg2 = img.copyCrop(faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());

      Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      recognitions.add(recognition);
      if (recognition.distance < 1.25) {
        _uploadData(DateTime.now().toIso8601String(), recognition.name,
            recognition.SID);
      }
    }
    drawRectangleAroundFaces();

    // call the method to perform face recognition on detected faces
  }

  // remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  _uploadData(String date, String name, int studentID) async {
    if (!SIDs.contains(studentID)) {
      await sheet!.values.appendRow([date, name, studentID]);
    }
  }

  // draw rectangles
  var image;
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    // print("${image.width}   ${image.height}");
    setState(() {
      recognitions;
      image;
      faces;
    });
  }

  List<Recognition> recognitions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recognize Face"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ?
              // Container(
              //         margin:  EdgeInsets.only(top: Layout.height(100)),
              //         width: Layout.getScreenWidth() - Layout.height(50),
              //         height: Layout.getScreenWidth() - Layout.height(50),
              //         child: Image.file(_image!),
              //       )
              Container(
                  margin: EdgeInsets.only(
                      top: Layout.height(60),
                      left: Layout.height(30),
                      right: Layout.height(30),
                      bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(
                            facesList: recognitions, imageFile: image),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: Layout.height(100)),
                  child: Image.asset(
                    "images/logo.png",
                    width: Layout.getScreenWidth() - Layout.height(100),
                    height: Layout.getScreenWidth() - Layout.height(100),
                  ),
                ),

          Container(
            height: Layout.height(50),
          ),

          // section which displays buttons for choosing and capturing images
          Container(
            margin: EdgeInsets.only(bottom: Layout.height(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Layout.height(200)))),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: Layout.getScreenWidth() / 2 - Layout.height(70),
                      height: Layout.getScreenWidth() / 2 - Layout.height(70),
                      child: Icon(Icons.image,
                          color: Colors.blue,
                          size: Layout.getScreenWidth() / 7),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Layout.height(200)))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: Layout.getScreenWidth() / 2 - Layout.height(70),
                      height: Layout.getScreenWidth() / 2 - Layout.height(70),
                      child: Icon(Icons.camera,
                          color: Colors.blue,
                          size: Layout.getScreenWidth() / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Recognition> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = imageFile.width < 300
        ? 4
        : imageFile.width < 1000
            ? 8
            : 12;

    for (Recognition rectangle in facesList) {
      canvas.drawRect(rectangle.location, p);

      TextSpan span = TextSpan(
          style: TextStyle(
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              color: Colors.white,
              fontSize: imageFile.width < 300
                  ? 9
                  : imageFile.width < 600
                      ? 10
                      : imageFile.width < 1000
                          ? 34
                          : imageFile.width < 2000
                              ? 48
                              : 62,
              fontWeight: FontWeight.bold),
          text: " ${rectangle.name}");
      // "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
