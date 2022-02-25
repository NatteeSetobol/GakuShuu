//
//  sqlite3_helper.h
//  GakuJuu
//
//  Created by Popcorn on 10/30/19.
//  Copyright © 2019 Popcorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define Assert 

NS_ASSUME_NONNULL_BEGIN

#define ArrayCount(Array) (sizeof(Array) / sizeof((Array)[0]))

enum sqlite3_type
{
  SQL3_NULL,
  SQL3_INTEGER,
  SQL3_REAL,
  SQL3_BLOB,
  SQL3_FUNCTION
};

typedef struct sql_data
{
    long* value;
    enum sqlite3_type type;
} sql_data;

@interface sqlite3_helper : NSObject
{
    sqlite3* database;
    bool finalize;
    bool hasClosed;
}

@property (nonatomic) sqlite3* database;

+ (id) GetDatabaseInstance;
-(sqlite3_stmt*) BeginSQLQuery : (NSString*) command;
-(NSMutableDictionary*) GetSQLNextRow: (sqlite3_stmt*) selectStatement;
-(void) Reset: (sqlite3_stmt*) selectStatement;
-(int) CountRowsInDatabase: (char*) dbName Statement: (char*) query;
-(NSMutableArray*) GetFromDatabase: (char*) tablename Query: (char*) query Statement: (char *) statement;
-(bool) UpdateColumn: (NSString*) tableName RowId: (int) rowId Query: (NSString*) query;
-(void) EndSQLQuery: (sqlite3_stmt*) selectStatement;
-(void) SetFinalize: (bool) state;
-(void) SQLRollBack;
-(void) SQLCommit;
-(NSString *) GetError;
-(NSMutableArray*) LoadFromDatabase: (char*) tablename Query: (char*) query Statement: (char *) statement;
-(int) GetLastInsertId;

-(bool) Insert: (NSString *) DatabaseName Values: (NSMutableArray *) Values;
-(bool) UpdateColumnBy: (NSString*) tableName Where: (NSString*) whereStatement Query: (NSString*) query;  

@end

NS_ASSUME_NONNULL_END
