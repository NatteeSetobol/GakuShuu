//
//  KanjiDatabase.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "KanjiDatabase.h"

@implementation KanjiDatabase

+ (id) GetInstance
{
    static KanjiDatabase *KanjiDatabaseInstance = nil;
    sqlite3_helper *SqlInstance = nil;
    @synchronized(self) {
        if (KanjiDatabaseInstance  == nil)
        {
            KanjiDatabaseInstance  = [[KanjiDatabase  alloc] init];
        }
    };
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    return KanjiDatabaseInstance;
}

- (bool) CreateDeck: (NSString *) DeckName Description: (NSString*) Description
{
    bool result = false;
    sqlite3_helper *SqlInstance = nil;
    NSMutableArray *Values = NULL;
    int lastId = 0;
    NSDateFormatter *TodayFormatter = NULL;
    NSDate *Today = NULL;
    NSString *TodayString=NULL;

    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    Today = [NSDate date];
    TodayFormatter = [[NSDateFormatter alloc] init];
    [TodayFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    TodayString = [TodayFormatter stringFromDate:Today];

    Values = [[NSMutableArray alloc] init];
    [Values addObject:@"0"];
    [Values addObject:DeckName];
    [Values addObject:@"0"];
    [Values addObject:@"NULL"];
    [Values addObject:Description];

   result = [SqlInstance Insert:@"decks" Values:Values];
    lastId = [self GetLastInsertedID];
    
    if ([self CreateOptions:lastId])
    {
        NSLog(@"Option Created");
    }
    return result;
}

-(bool) CreateKanji: (int) deckId Kanji: (NSMutableArray*) kanjiInfo
{
    bool inserted = false;
    sqlite3_helper *SqlInstance = nil;
    
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    inserted = [SqlInstance Insert:@"kanjis" Values:kanjiInfo];
    

    return inserted;
}

-(bool) CreateOptions: (int) DeckId
{
    bool inserted = false;
    sqlite3_helper *SqlInstance = nil;
    NSMutableArray *DeckOptionsInfo = [[NSMutableArray alloc] init];
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    // NOTES(): These are default values.
    [DeckOptionsInfo addObject:@"NULL"];
    [DeckOptionsInfo addObject:[NSString stringWithFormat:@"%i", DeckId]];
    [DeckOptionsInfo addObject:@"5"];
    [DeckOptionsInfo addObject:@"10"];
    [DeckOptionsInfo addObject:@"1"];

    inserted = [SqlInstance Insert:@"options" Values:DeckOptionsInfo];
    
    
    
    return inserted;
}

-(NSMutableArray *) GetAllDecks
{
    NSMutableArray *Decks = NULL;
    sqlite3_helper *SqlInstance = nil;
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    Decks = [SqlInstance GetFromDatabase:"decks" Query: "*" Statement:""];
    
    return Decks;
}

-(NSMutableArray *) GetDeck: (int) DeckID
{
    NSMutableArray *Decks = NULL;
    sqlite3_helper *SqlInstance = nil;
    NSString *SQLStatement = nil;
    
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    SQLStatement = [NSString stringWithFormat:@"where id=%i", DeckID];
    
    Decks = [SqlInstance GetFromDatabase:"decks" Query: "*" Statement: (char*) [SQLStatement UTF8String] ];
    
    
    return Decks;
}

-(NSMutableArray *) GetDeckOptions: (int) DeckID
{
    NSMutableArray *DeckOptions = NULL;
    sqlite3_helper *SqlInstance = nil;
    NSString *SQLStatement = nil;
    
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    SQLStatement = [NSString stringWithFormat:@"where deckid=%i", DeckID];
    
    DeckOptions = [SqlInstance GetFromDatabase:"options" Query: "*" Statement: (char*) [SQLStatement UTF8String] ];
    
    return DeckOptions;
}

-(NSMutableArray *) GetAllCardsFromDeck: (int) DeckID
{
    NSMutableArray *Cards = NULL;
    sqlite3_helper *SqlInstance = nil;
    NSString *SQLStatement = nil;
    
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    SQLStatement = [NSString stringWithFormat:@"where deckid=%i", DeckID];
    Cards = [SqlInstance GetFromDatabase:"kanjis" Query: "*" Statement: (char*) [SQLStatement UTF8String] ];
    
    return Cards;
}

-(int) GetLastInsertedID
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    return [SqlInstance GetLastInsertId];
}

-(bool) UpdateOption: (int) DeckID Option: (NSString*) option OptionValue: (NSString*) optionValue
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    return [SqlInstance UpdateColumnBy:@"options" Where:[NSString stringWithFormat:@"deckid=%i", DeckID] Query:[NSString stringWithFormat:@"%@=%@", option, optionValue ]];

}

-(bool) UpdateDeck: (int) DeckID DeckName: (NSString*) deckName DeckDescription: description
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    return [SqlInstance UpdateColumnBy:@"decks" Where:[NSString stringWithFormat:@"id=%i", DeckID] Query:[NSString stringWithFormat:@"name=\'%@\', description=\'%@\'", deckName, description ]];

}

-(bool) UpdateCardStatus: (int) CardId DueDate: (NSString*) DueDate Quality: (int) Quality Interval: (int) Interval EaseFactor: (float) EaseFactor Repetitions: (int) Repetition
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    return [SqlInstance UpdateColumnBy:@"kanjis" Where:[NSString stringWithFormat:@"id=%i", CardId] Query:[NSString stringWithFormat:@"duedate=\"%@\"   , quality=%i, interval=%i, easefactor=%f, repetitions=%i", DueDate, Quality, Interval, EaseFactor, Repetition ]];
}

-(NSMutableArray*) ChooseNewKanjis: (int) DeckId Limit: (int) Limit
{
    sqlite3_helper *SqlInstance = nil;
    NSMutableArray *RowResult = NULL;
    NSString *query = NULL;

    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    query = [NSString stringWithFormat:@"where deckid=%i AND duedate = '0' ORDER BY RANDOM() LIMIT %i", DeckId, Limit];
    
    RowResult = [SqlInstance GetFromDatabase: "kanjis" Query: "*"  Statement: (char*) [query UTF8String] ];

    
    return RowResult;
}

-(bool) UpdateKanjiDueDate: (int) CardID DueDate: (NSString*) DueDate
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    return [SqlInstance UpdateColumnBy:@"kanjis" Where:[NSString stringWithFormat:@"id=%i", CardID] Query:[NSString stringWithFormat:@"duedate=\"%@\"", DueDate ]];

}

-(bool) UpdateDeckDueDate: (int) DeckID DueDate: (NSString*) DueDate
{
    sqlite3_helper *SqlInstance = nil;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    return [SqlInstance UpdateColumnBy:@"decks" Where:[NSString stringWithFormat:@"id=%i", DeckID] Query:[NSString stringWithFormat:@"nextdue=\"%@\"", DueDate ]];

}

-(NSMutableArray*) GetDueKanjis: (int) DeckId
{
    sqlite3_helper *SqlInstance = nil;
    NSMutableArray *RowResult = NULL;
    NSString *query = NULL;
    NSDateFormatter *TodayFormatter = NULL;
    NSDate *Today = NULL;
    NSString *TodayString=NULL;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    Today = [NSDate date];
    TodayFormatter = [[NSDateFormatter alloc] init];
    [TodayFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    TodayString = [TodayFormatter stringFromDate:Today];

    
    query = [NSString stringWithFormat:@"where deckid=%i and duedate <= '%@' ", DeckId, TodayString];
    
    RowResult = [SqlInstance GetFromDatabase: "kanjis" Query: "*"  Statement: (char*) [query UTF8String] ];

    return RowResult;
}

-(bool) deleteDeck: (int) ID
{
    sqlite3_helper *SqlInstance = nil;
    bool didDeleteFromDeck = false;
    bool didDeleteCardsFromDeck = false;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];

    didDeleteCardsFromDeck = [SqlInstance deleteFromDatabase:@"kanjis" Where: [NSString stringWithFormat:@"deckid=%i", ID]];
    
    didDeleteFromDeck = [SqlInstance deleteFromDatabase:@"decks" Where: [NSString stringWithFormat:@"id=%i", ID]];
    
 
    return (didDeleteFromDeck && didDeleteCardsFromDeck);
}

-(bool) deleteCard: (int) ID
{
    sqlite3_helper *SqlInstance = nil;
    bool didDeleteFromCards = false;
    
    SqlInstance = [sqlite3_helper GetDatabaseInstance];
    
    didDeleteFromCards = [SqlInstance deleteFromDatabase:@"kanjis" Where: [NSString stringWithFormat:@"id=%i", ID]];
    
    return didDeleteFromCards;
}

@end
