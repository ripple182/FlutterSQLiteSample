//
//  SQLiteProvider.m
//  Runner
//
//  Created by Chris Ripple on 2/6/17.
//  Copyright © 2017 The Chromium Authors. All rights reserved.
//


#import "DatabaseInitializer.h"

@implementation DatabaseInitializer

@synthesize messageName = _messageName;

- (instancetype) init {
    self = [super init];
    if (self)
        self->_messageName = @"initDatabase";
    
    return self;
}

- (NSString*)didReceiveString:(NSString*)message
{
    [self setSqliteProvider: [[SQLiteProvider alloc] init]];
    [_sqliteProvider setDatabaseName:message];
    [_flutterController addMessageListener: _sqliteProvider];
    
    return @"";
}

@end
