//
//  SQLiteProvider.h
//  Runner
//
//  Created by Chris Ripple on 2/6/17.
//  Copyright © 2017 The Chromium Authors. All rights reserved.
//

#import <Flutter/Flutter.h>

@interface SQLiteProvider : NSObject <FlutterMessageListener>

@property (nonatomic, retain) NSString* databaseName;

@end
