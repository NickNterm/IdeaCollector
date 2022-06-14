import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:idea_collector/Constants/colors.dart';
import 'package:idea_collector/Models/Idea.dart';
import 'package:idea_collector/Screens/MainScreen/Animation/Animator.dart';
import 'package:idea_collector/Screens/MainScreen/Components/HelloTItle.dart';
import 'package:idea_collector/Screens/MainScreen/Components/IdeaGridTileView.dart';
import 'package:idea_collector/Screens/MainScreen/Components/TitleWithAddButton.dart';
import 'package:idea_collector/Services/SqlLite.dart';
import 'package:sqflite/sqlite_api.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late MainScreenAnimator myAnimations;
  late Database db;
  List<Idea> ideas = [];
  List<Idea> filteredIdeas = [];

  // Its a async function that sets up the database and
  // updates the ideas for the list view
  void setDB() async {
    db = await initDatabase();
    setState(() {});
    updateIdeas();
  }

  // Runs only on the Start of the app
  // It initialize the animation Controller and starts the animation
  // Plus it initialize the database
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    setDB();
    myAnimations = MainScreenAnimator(context, controller);

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {}
  }

  // reads all the ideas from the sqfLite and set it on the
  // filteredList that is displayed on list view
  void updateIdeas() async {
    ideas = await getAllIdeas(db);
    setState(() {
      filteredIdeas.clear();
      filteredIdeas.addAll(ideas);
    });
  }

  // this Function gets called every time the value of the search
  // bar is changed. The List view displays the filteredList so
  // that function filters the ideas and shows only the ones that contains
  // the searchValue
  void changeFilter(String searchValue) {
    print(ideas.length);
    List SearchList = [];
    SearchList.addAll(ideas);
    if (searchValue.isNotEmpty) {
      List<Idea> dummyListData = [];
      for (var item in ideas) {
        if (item.title
            .toString()
            .toUpperCase()
            .contains(searchValue.toUpperCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredIdeas.clear();
        filteredIdeas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredIdeas.clear();
        filteredIdeas.addAll(ideas);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myAnimations.initAnimations();
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: AnimatedBuilder(
            animation: controller,
            builder: ((context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: myAnimations.getTextOpacity().value,
                    child: const HelloTitle(),
                  ),
                  Stack(
                    children: [
                      Positioned.fill(
                        bottom: 140,
                        child: Center(
                          child: Opacity(
                            opacity: myAnimations.getIconOpacity().value,
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        transform: Matrix4.translationValues(
                          0.0,
                          myAnimations.getBannertranslation().value,
                          0.0,
                        ),
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              100 -
                              MediaQuery.of(context).viewPadding.top,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                transform: Matrix4.translationValues(
                                  myAnimations.getAddRowtranslation().value,
                                  0,
                                  0,
                                ),
                                child: TitleRowWithAddButton(
                                  updateList: updateIdeas,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      )
                                    ]),
                                transform: Matrix4.translationValues(
                                  -myAnimations.getAddRowtranslation().value,
                                  0,
                                  0,
                                ),
                                child: TextField(
                                  onChanged: (value) => changeFilter(value),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: filteredIdeas.isNotEmpty
                                  ? MasonryGridView.count(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      itemCount: filteredIdeas.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Idea idea = filteredIdeas[index];
                                        return Opacity(
                                          opacity: myAnimations
                                              .getTileOpacity()
                                              .value,
                                          child: ScaleTransition(
                                            scale: myAnimations.getTileScale(),
                                            child: IdeaGridTileView(
                                              idea: idea,
                                              updateIdeas: updateIdeas,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Opacity(
                                      opacity:
                                          myAnimations.getTileOpacity().value,
                                      child: const Center(
                                        child: Text(
                                          "Add Some New Ideas",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
