import 'dart:math';

import 'package:flutter/material.dart';
import 'package:idea_collector/Models/Idea.dart';
import 'package:idea_collector/Screens/AddScreen/AddScreen.dart';
import 'package:idea_collector/Services/SqlLite.dart';

class IdeaGridTileView extends StatelessWidget {
  const IdeaGridTileView({
    Key? key,
    required this.idea,
    required this.updateIdeas,
  }) : super(key: key);

  final Idea idea;
  final Function updateIdeas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
              color: Color(idea.color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onLongPress: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Are you sure you want to delete this idea?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            deleteIdeaWithId(await initDatabase(), idea);
                            updateIdeas();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddScreen(
                      idea: idea,
                    ),
                  ),
                ).then((value) => updateIdeas());
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            idea.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 50),
                      child: Text(
                        idea.idea,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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
