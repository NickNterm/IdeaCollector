import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:idea_collector/Constants/colors.dart';
import 'package:idea_collector/Models/Idea.dart';
import 'package:idea_collector/Services/SqlLite.dart';
import 'package:sqflite/sqlite_api.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key, this.idea}) : super(key: key);

  final Idea? idea;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController ideaController = TextEditingController();
  List<Color> colorList = [
    kRedColor,
    kPinkColor,
    kPurpleColor,
    kDeepPurpleColor,
    kIndigoColor,
    kBlueColor,
    kLightBlueColor,
    kCyanColor,
    kTealColor,
    kGreenColor,
    kLightGreenColor,
    kLimeColor,
    kYellowColor,
    kAmberColor,
    kOrangeColor,
    kDeepOrangeColor,
    kBrownColor,
  ];
  late Color currentColor;
  late Database db;
  void setDB() async {
    db = await initDatabase();
  }

  @override
  void initState() {
    super.initState();
    setDB();
    setState(() {
      if (widget.idea != null) {
        currentColor = Color(widget.idea!.color);
        titleController.text = widget.idea!.title;
        ideaController.text = widget.idea!.idea;
      } else {
        currentColor = colorList[Random().nextInt(colorList.length)];
      }
    });
  }

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = currentColor;
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SizedBox(
            height: 320,
            child: BlockPicker(
              useInShowDialog: true,
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              availableColors: colorList,
            ),
          ),
          actions: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                child: Ink(
                  color: kPrimaryColor,
                  child: InkWell(
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Got it',
                          style: TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      setState(() {
                        currentColor = pickerColor;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Express Your Thoughts",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showColorPicker(),
                        child: AnimatedContainer(
                          margin: const EdgeInsets.all(20),
                          duration: const Duration(seconds: 1),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  /*AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: 55,
                    color: currentColor,
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "New Idea",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          showColorPicker();
                        },
                        child: const Text(
                          "Color",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ]),
                  ),*/

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Title',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          TextFormField(
                            controller: ideaController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Your Idea',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  if (titleController.text.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text('Please enter a title'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  if (ideaController.text.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text('Please enter an idea'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  if (widget.idea == null) {
                    setNewIdea(
                      db,
                      Idea(
                        0,
                        titleController.text,
                        ideaController.text,
                        currentColor.value.toInt(),
                      ),
                    );
                  } else {
                    updateIdeaWithId(
                      db,
                      Idea(
                        widget.idea!.id,
                        titleController.text,
                        ideaController.text,
                        currentColor.value.toInt(),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  width: 50,
                  height: 50,
                  duration: const Duration(seconds: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: currentColor,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
