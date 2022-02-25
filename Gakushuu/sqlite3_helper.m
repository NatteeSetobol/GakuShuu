//
//  sqlite3_helper.m
//  GakuJuu
//
//  Created by Popcorn on 10/30/19.
//  Copyright © 2019 Popcorn. All rights reserved.
//

#import "sqlite3_helper.h"

@implementation sqlite3_helper

@synthesize database;





+ (id) GetDatabaseInstance
{
    static sqlite3_helper *sqlHelper = nil;
   // static dispatch_once_t onceToken;
    //static bool isDatabaseOpen = false;
    @synchronized(self) {
        if (sqlHelper == nil)
        {
            sqlHelper = [[sqlite3_helper alloc] init];
            [sqlHelper OpenData:@"database.sqlite3"];
        }
    };

    return sqlHelper;
}

-(bool) OpenData: (NSString*) filename
{
    bool result = false;
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
    
        char* pathString = (char*) [path UTF8String];
        sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

        if  (sqlite3_open(pathString, &sqlhelper->database) == SQLITE_OK)
        {
            result = true;
            NSLog(@"Database Opened");

        } else {
            NSLog(@"Can't not open database!");
        }
    } else {
        NSLog(@"Database file not found!");
        bool success = false;
        NSError *error;
        
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        success = [[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:path error:&error];
        
        if (!success)
        {
            NSLog(@"Can not copy file %@",error.description);
        } else {
            NSLog(@"Trying to open file Again...");
            result =  [self OpenData:filename];
        }
    }
    return result;
}


-(int) CountRowsInDatabase: (char*) dbName Statement: (char*) query
{
    int result = 0;
    NSString *statement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    
    statement = [[NSString alloc] initWithFormat:@"select COUNT(*) from %s %s", dbName, query];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [statement UTF8String], -1, &selectStatement,NULL) == SQLITE_OK)
    {
        if ((sqlite3_step(selectStatement) == SQLITE_ROW))
        {
            result = sqlite3_column_int(selectStatement, 0);
        }
        sqlite3_finalize(selectStatement);
    }
    return result;
}

-(NSMutableDictionary*) GetColumns: (sqlite3_stmt*) statement
{
    NSMutableDictionary * results = 0;
    int columnCount = 0;
    
    results = [[NSMutableDictionary alloc] init];
    
    columnCount = sqlite3_column_count(statement);
    
    for (int columnIndex = 0;columnIndex < columnCount; columnIndex++)
    {
        int columnType = 0;
        char *columnName = 0;
        
        columnType = sqlite3_column_type(statement,columnIndex);
        columnName = (char*) sqlite3_column_name(statement, columnIndex);
        
        switch(columnType)
        {
            case SQLITE_INTEGER:
            {
                int intData = 0;
                NSNumber *newNumber = NULL;
                NSString *keyName  = NULL;
                
                intData = sqlite3_column_int(statement,columnIndex);
                newNumber = [[NSNumber alloc] initWithInt:intData];
                
                keyName = [NSString stringWithFormat:@"%s", columnName];
                [results setValue:newNumber forKey: keyName];
            
                break;
            }
            case SQLITE_FLOAT:
            {
                float floatData = 0.00f;
                NSNumber *floatNumber = NULL;
                NSString *keyName = NULL;

                floatData = sqlite3_column_double(statement,columnIndex);
                floatNumber = [[NSNumber alloc] initWithFloat:floatData];
                
                keyName = [NSString stringWithFormat:@"%s", columnName];
                [results setValue: floatNumber forKey: keyName];
    
                break;
            }
            case SQLITE_TEXT:
            {
                char* sqlText = NULL;
                NSString *stringValue = NULL;
                NSString *keyName = 0;

                sqlText = (char*) sqlite3_column_text(statement,columnIndex);
                stringValue = [[NSString alloc] initWithUTF8String:sqlText];
                
                keyName = [NSString stringWithFormat:@"%s", columnName];
                [results setValue:stringValue forKey:keyName];
                break;
            }
        }
    }
    return results;
}

-(NSMutableArray*) LoadFromDatabase: (char*) tablename Query: (char*) query Statement: (char *) statement
{
    
    char *select = NULL;
    NSString *sqlStatement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    int totalCardsInDeck = 0;
    NSMutableArray *result = NULL;
    
    totalCardsInDeck = [self CountRowsInDatabase:tablename Statement:statement];
    
    result = [[NSMutableArray alloc] init];
    
    sqlStatement = [[NSString alloc] initWithFormat:@"select %s from %s %s", query,tablename,statement];
    
    select = (char*) [sqlStatement UTF8String];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [sqlStatement UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            NSMutableDictionary* columns = 0;
            
            columns = [self GetColumns:selectStatement];
  
            [result addObject:columns];
            
        }
    }
    sqlite3_finalize(selectStatement);

    return result;
}

-(NSMutableArray*) GetFromDatabase: (char*) tablename Query: (char*) query Statement: (char *) statement
{
    
    char *select = NULL;
    NSString *sqlStatement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    int totalCardsInDeck = 0;
    NSMutableArray *result = NULL;
    
    totalCardsInDeck = [self CountRowsInDatabase:tablename Statement:statement];
    
    result = [[NSMutableArray alloc] init];
    
    sqlStatement = [[NSString alloc] initWithFormat:@"select %s from %s %s", query,tablename,statement];
    
    select = (char*) [sqlStatement UTF8String];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [sqlStatement UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
                        
            NSMutableDictionary* columns = 0;
            
            columns = [self GetColumns:selectStatement];
  
            [result addObject:columns];
            
        }
    }
    sqlite3_finalize(selectStatement);

   // [self Close];
    return result;
}

-(bool) UpdateColumn: (NSString*) tableName RowId: (int) rowId Query: (NSString*) query
{
    bool result = false;
    char *select = NULL;
    NSString *sqlStatement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    
    sqlStatement = [[NSString alloc] initWithFormat:@"Update %@ set %@ where id=%i", tableName,query,rowId];
    
    select = (char*) [sqlStatement UTF8String];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [sqlStatement UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(selectStatement) == SQLITE_DONE)
        {
            result = true;
            sqlite3_finalize(selectStatement);
            //]self Reset:selectStatement];

          
        } else {
            char *errorMsg = (char*) sqlite3_errmsg(database);
            NSLog(@"%s", errorMsg);
        }

    } else {
        char *errorMsg = (char*) sqlite3_errmsg(database);
        NSLog(@"%s", errorMsg);
    }
 //   [self Close];
    return result;
}



-(sqlite3_stmt*) BeginSQLQuery : (NSString*) command
{
    
    sqlite3_stmt *result=NULL;
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [command UTF8String], -1, &result, NULL) == SQLITE_OK)
    {
        
    }
    
    return result;
}

-(bool) UpdateColumnBy: (NSString*) tableName Where: (NSString*) whereStatement Query: (NSString*) query
{
    bool result = false;
    char *select = NULL;
    NSString *sqlStatement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    
    sqlStatement = [[NSString alloc] initWithFormat:@"Update %@ set %@ where %@", tableName,query,whereStatement];
    
    select = (char*) [sqlStatement UTF8String];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [sqlStatement UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(selectStatement) == SQLITE_DONE)
        {
            result = true;
            sqlite3_finalize(selectStatement);
        } else {
            char *errorMsg = (char*) sqlite3_errmsg(database);
            NSLog(@"%s", errorMsg);
        }

    } else {
        char *errorMsg = (char*) sqlite3_errmsg(database);
        NSLog(@"%s", errorMsg);
    }
 //   [self Close];
    return result;
}


-(NSMutableDictionary*) GetSQLNextRow: (sqlite3_stmt*) selectStatement
{
    int columnCount = 0;
    NSMutableDictionary *result = NULL;
    finalize = true;
    
    if (sqlite3_step(selectStatement) == SQLITE_ROW)
    {
        columnCount = sqlite3_column_count(selectStatement);
        
        if (columnCount != 0)
        {
            result = [self GetColumns:selectStatement];

        }
    } else {
        finalize = false;
    }

    return result;
}

-(void) SetFinalize: (bool) state
{
    finalize = state;
}

-(void) EndSQLQuery: (sqlite3_stmt*) selectStatement
{
    sqlite3_finalize(selectStatement);
}

-(void) Reset: (sqlite3_stmt*) selectStatement
{
    sqlite3_reset(selectStatement);
}

-(void) SQLRollBack
{
    bool result = false;
    
    result = [self RunCommand:@"rollback"];
    
    if (result)
    {
        NSLog(@"rolled back!");
    } else {
        NSLog(@"error!");
    }
}
-(void) SQLCommit
{
    bool result = false;
    
    result = [self RunCommand:@"commit"];
    
    if (result)
    {
        NSLog(@"commited!");
    } else {
        NSLog(@"error!");
    }
}

-(bool) RunCommand: (NSString *) command
{
    bool result = false;
    sqlite3_stmt *selectStatement=NULL;
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];

    if (sqlite3_prepare_v2(sqlhelper->database, [command UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(selectStatement) == SQLITE_DONE)
        {
            result = true;
            sqlite3_finalize(selectStatement);
            
        } else {

            char *errorMsg = (char*) sqlite3_errmsg(sqlhelper->database);
            NSLog(@"%s", errorMsg);
        }
        
    }
    
    return result;
}

-(bool) Insert: (NSString *) DatabaseName Values: (NSMutableArray *) Values
{
    bool didInsert = false;
    NSString *ValueString = NULL;
    NSString *SQLCommand = NULL;
    
    
    for (int i=0; i < [Values count]; i++)
    {
        if (ValueString)
        {
            ValueString = [NSString stringWithFormat:@"%@,\"%@\"", ValueString, [Values objectAtIndex:i]];
        } else {
            // NOTES(): The first column will always be the id which is autoincremented in the
            // database
            ValueString = [NSString stringWithFormat:@"NULL"];
        }
    }
    
    SQLCommand = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(%@)", DatabaseName, ValueString];
    
    didInsert = [self RunCommand:SQLCommand];
    
    return didInsert;
}



-(NSString *) GetError
{
    NSString *result=NULL;
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];
    char *errorMsg = (char*) sqlite3_errmsg(sqlhelper->database);
    if (errorMsg)
    {
        result = [NSString stringWithFormat:@"%s", errorMsg];
    }
    
    return result;
}

-(int) GetLastInsertId
{
    
    char *select = NULL;
    NSString *sqlStatement = NULL;
    sqlite3_stmt *selectStatement=NULL;
    
    sqlStatement = @"SELECT LAST_INSERT_ROWID() AS ID";
    
    select = (char*) [sqlStatement UTF8String];
    sqlite3_helper *sqlhelper = [sqlite3_helper GetDatabaseInstance];
    NSNumber *NSId;

    if (sqlite3_prepare_v2(sqlhelper->database, [sqlStatement UTF8String], -1, &selectStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
                        
            NSMutableDictionary* columns = 0;
            
            columns = [self GetColumns:selectStatement];
            
            NSId = [columns objectForKey:@"ID"];
        }
    }
    sqlite3_finalize(selectStatement);

   // [self Close];
    return [NSId intValue];
}
@end
