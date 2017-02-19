import 'dart:collection';

class Goal
{
    int id;
    String name;

    Goal(this.id, this.name);

    static fromMap(Map map)
    {
        return new Goal(map["id"], map["name"]);
    }
}