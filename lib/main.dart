import 'package:flutter/material.dart';
import 'ExampleRepository.dart';
import 'Goal.dart';
import 'dart:async';

void main()
{
    var repository = new ExampleRepository();

    //once the database finishes initializing then we can run the Flutter app
    repository.init("goal_database.db", 1).then((_)
    {
        runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return new MaterialApp(
            title: 'Flutter Demo',
            theme: new ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: new MyHomePage(title: 'Flutter Demo Home Page'),
            routes: <String, WidgetBuilder>{
                '/new': (BuildContext context)
                => new NewGoalPage(title: 'New Goal'),
            },
        );
    }
}

class MyHomePage extends StatefulWidget
{
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState()
    => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
    static final GlobalKey<ScrollableState> _scrollableKey = new GlobalKey<ScrollableState>();

    List<Goal> _goals;
    StreamSubscription<Goal> newGoalSubscription;

    @override
    void initState()
    {
        super.initState();
        newGoalSubscription = new ExampleRepository().newGoal.stream.listen((_) => refreshGoalList());
    }

    @override
    Widget build(BuildContext context)
    {
        Widget body;

        //goals not loaded yet
        if (_goals == null)
        {
            body = new Center(
                child: new Text(
                    'Loading goals...',
                ),
            );

            //async load goals then refresh UI
            refreshGoalList();
        }
        else
        {
            final double statusBarHeight = MediaQuery
                .of(context)
                .padding
                .top;

            final List<Widget> widgetList = <Widget>[];

            _goals.forEach((_)
            {
                widgetList.add(
                    new Card(key: new Key("goal-${_.id}"),
                        child: new Center(
                            child: new Text(
                                _.name,
                            )
                        ))
                );
            });

            body = new Block(
                scrollableKey: _scrollableKey,
                padding: new EdgeInsets.only(top: statusBarHeight, bottom: 65.0),
                children: widgetList,
            );
        }

        return new Scaffold(
            appBar: new AppBar(
                title: new Text(config.title),
            ),
            body: body,
            floatingActionButton: new FloatingActionButton(
                onPressed: ()
                => Navigator.pushNamed(context, "/new"),
                tooltip: 'New Goal',
                child: new Icon(Icons.add),
            ),
        );
    }

    @override
    void dispose()
    {
        super.dispose();
        newGoalSubscription.cancel();
    }

    void refreshGoalList()
    {
        new ExampleRepository().getGoals().then((_)
        {
            setState(()
            {
                _goals = _;
            });
        });
    }
}


class NewGoalPage extends StatefulWidget
{
    NewGoalPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _NewGoalState createState()
    => new _NewGoalState();
}

class _NewGoalState extends State<NewGoalPage>
{
    String _name = "";

    @override
    Widget build(BuildContext context)
    {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(config.title),
            ),
            body: new Center(
                child: new Input(
                    key: new Key("editing-goal-name"),
                    hintText: "Enter a new goal",
                    labelText: "Goal Name",
                    value: new InputValue(text: _name),
                    onChanged: (InputValue val)
                    {
                        setState(()
                        {
                            _name = val.text;
                        });
                    }
                ),
            ),
            floatingActionButton: new FloatingActionButton(
                onPressed: ()
                => save(),
                tooltip: 'Save Goal',
                child: new Icon(Icons.check),
            ),
        );
    }

    void save()
    {
        new ExampleRepository().saveGoal(new Goal(-1, _name));
        Navigator.of(context).pop();
    }
}
