# FlutterSQLiteSample
Sample app that exposes SQLite to flutter/dart via flutter services.

## Install Steps
1. Setup your app to be an embedded FlutterView, see [hello_services app](https://github.com/flutter/flutter/tree/master/examples/hello_services)
2. copy `RawSQLiteHelper.java` to the same package as your main Android Activity
3. setup your activity to look something like this:
    ```
    private RawSQLiteHelper sqLiteHelper;
    private FlutterView flutterView;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        FlutterMain.ensureInitializationComplete(getApplicationContext(), null);
        setContentView(R.layout.hello_services_layout);

        flutterView = (FlutterView) findViewById(R.id.flutter_view);
        flutterView.runFromBundle(FlutterMain.findAppBundlePath(getApplicationContext()), null);

        final Context context = this;
        flutterView.addOnMessageListener("initDatabase", new FlutterView.OnMessageListener()
        {
            @Override
            public String onMessage(FlutterView flutterView, String s)
            {
                sqLiteHelper = new RawSQLiteHelper(context, flutterView, s, 1);

                return "";
            }
        });
    }
    ```
4. Update your ios `Podfile` to include **FMDB**:
    ```
target 'Runner' do

  # Pods for Runner
  pod 'FMDB'

end
    ```
5. run `pod install --no-repo-update` to install the *FMBD* pod
6. Copy the following files to your ios sub-project (should be called Runner):
    ```
DatabaseInitializer.h
DatabaseInitializer.m
SQLiteProvider.h
SQLiteProvider.m
    ```
7. Update `AppDelegate.m` to look something like this:
    ```
#import <Flutter/Flutter.h>
#include "AppDelegate.h"
#import "SQLiteProvider.h"
#import "DatabaseInitializer.h"

@implementation AppDelegate {
    DatabaseInitializer* _databaseInitializer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    FlutterDartProject* project = [[FlutterDartProject alloc] initFromDefaultSourceForConfiguration];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    FlutterViewController* flutterController = [[FlutterViewController alloc] initWithProject:project
                                                                                      nibName:nil
                                                                                       bundle:nil];
    _databaseInitializer = [[DatabaseInitializer alloc] init];
    [_databaseInitializer setFlutterController:flutterController];
    [flutterController addMessageListener: _databaseInitializer];

    self.window.rootViewController = flutterController;
    [self.window makeKeyAndVisible];

    return YES;
}
    ```
8. Copy `SQLiteDatabase.dart` to your flutter project (lib folder)
9. Now you can extend `SQLiteDatabase` to create your own repository, similar to how you extend `android.database.sqlite.SQLiteDatabase` in native android.  See example `ExampleRepository` for an example.  `createDatabase` and `updateDatabase` act like `android.database.sqlite.SQLiteDatabase` as well.
