//
//  SQLiteProvider.m
//  Runner
//
//  Created by Chris Ripple on 2/6/17.
//  Copyright © 2017 The Chromium Authors. All rights reserved.
//


#import "SQLiteProvider.h"
#import "FMDB/FMDB.h"

@implementation SQLiteProvider

@synthesize messageName = _messageName;

- (instancetype) init {
    self = [super init];
    if (self)
        self->_messageName = @"rawQuery";
    
    return self;
}

- (NSString*)didReceiveString:(NSString*)message
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[self databaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if (![db open]) {
        db = nil;
        return @"";
    }
    
    FMResultSet *s = [db executeQuery:message];
    
    NSString *string = @"";

    NSMutableArray *array = [[NSMutableArray alloc] init];
  
    while([s next])
    {
        NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
                
        int count = [s columnCount];
        for (int i = 0; i < count; i++)
        {
            NSString *columnName = [s columnNameForIndex:i];
            NSObject *object = [s objectForColumnIndex: i];

            [map setValue:object forKey: columnName];
        }
                
        [array addObject:map];
    }
            
    string = [self json:array];
    
    [db close];
    
    return string;
}

- (NSString*)json:(NSArray*)array
{
    NSString* json = nil;
    
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return (error ? nil : json);
}

@end
