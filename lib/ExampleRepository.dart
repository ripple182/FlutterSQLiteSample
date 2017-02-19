import 'SQLiteDatabase.dart';
import 'Goal.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

class ExampleRepository extends SQLiteDatabase
{
    static final ExampleRepository _singleton = new ExampleRepository._internal();

    factory ExampleRepository() {
        return _singleton;
    }

    ExampleRepository._internal();

    final StreamController<Goal> _newGoal = new StreamController<Goal>();
    StreamController<Goal> get newGoal => _newGoal;

    @override
    void createDatabase()
    {
        query("CREATE TABLE IF NOT EXISTS GOALS (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);");
        saveGoal(new Goal(-1, "Code"));
        saveGoal(new Goal(-1, "Sleep"));
        saveGoal(new Goal(-1, "Exercise"));
    }

    @override
    void updateDatabase(int oldVersion, int newVersion)
    {

    }

    Future saveGoal(Goal goal)
    async
    {
        await query("INSERT INTO GOALS VALUES (null, \"${goal.name}\");");

        _newGoal.add(goal);
    }

    Future<List<Goal>> getGoals()
    async
    {
        var json = await query("SELECT * FROM GOALS");
        var list = JSON.decode(json) as List;

        var goalList = new List<Goal>();

        for (var map in list)
        {
            goalList.add(Goal.fromMap(map));
        }

        return goalList;
    }
}