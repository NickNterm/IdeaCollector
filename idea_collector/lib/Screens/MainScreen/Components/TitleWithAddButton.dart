import 'package:flutter/material.dart';
import 'package:idea_collector/Constants/colors.dart';
import 'package:idea_collector/Screens/AddScreen/AddScreen.dart';

class TitleRowWithAddButton extends StatelessWidget {
  const TitleRowWithAddButton({
    Key? key,
    required this.updateList,
  }) : super(key: key);
  final Function updateList;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "My Ideas",
          style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.7)),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            child: Ink(
              color: Colors.white,
              child: InkWell(
                splashColor: kPrimaryColor.withOpacity(0.5),
                highlightColor: kPrimaryColor.withOpacity(0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddScreen(),
                    ),
                  ).then((value) => updateList());
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "+ Add Idea",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
