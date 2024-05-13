import 'dart:io';
import 'dart:typed_data';
import 'package:cwdapp/ML/Recognizer.dart';
import 'package:cwdapp/ML/recognitions.dart';
import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
  @override
  void initState() {
    // : implement initState
    super.initState();
    imagePicker = ImagePicker();

    // initialize face detector
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    // initialize face recognizer
    recognizer = Recognizer();
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
      //showFaceRegistrationDialogue(Uint8List.fromList(img.encodePng(faceImg2)), recognition);
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

  // perform Face Recognition

  // Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    textEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  // draw rectangles
  var image;
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
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
        title: const Text("Attendance"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go('/attendance');
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
    p.strokeWidth = 3;

    for (Recognition rectangle in facesList) {
      canvas.drawRect(rectangle.location, p);

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 30),
          text: "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
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
