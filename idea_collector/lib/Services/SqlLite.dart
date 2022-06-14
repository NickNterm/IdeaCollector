import 'package:idea_collector/Models/Idea.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE Ideas (id INTEGER PRIMARY KEY, title TEXT, idea TEXT, color NUM)');
  });
  return database;
}

Future<Idea> getNoteWithId(Database db, int id) async {
  List<Map> maps = await db.query("Ideas", whereArgs: [id]);
  if (maps.length > 0) {
    return Idea(
      maps.first["id"],
      maps.first["title"],
      maps.first["idea"],
      maps.first["color"],
    );
  }
  return Idea(0, "", "", 0);
}

Future<List<Idea>> getAllIdeas(Database db) async {
  List<Map> maps = await db.query("Ideas");
  List<Idea> ideas = [];
  for (var idea in maps) {
    ideas.add(Idea(
      idea["id"],
      idea["title"],
      idea["idea"],
      idea["color"],
    ));
  }
  return ideas;
}

void setNewIdea(Database db, Idea idea) async {
  await db.insert(
      "Ideas", {"title": idea.title, "idea": idea.idea, "color": idea.color});
}

void updateIdeaWithId(Database db, Idea idea) async {
  await db.update(
    "Ideas",
    {
      "title": idea.title,
      "idea": idea.idea,
      "color": idea.color,
    },
    where: 'id = ?',
    whereArgs: [idea.id],
  );
}

void deleteIdeaWithId(Database db, Idea idea) async {
  await db.delete(
    "Ideas",
    where: 'id = ?',
    whereArgs: [idea.id],
  );
}
