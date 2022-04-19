//
//  KanjiDatabase.h
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import <Foundation/Foundation.h>
#include "sqlite3_helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface KanjiDatabase : NSObject

+ (id) GetInstance;
- (bool) CreateDeck: (NSString *) DeckName Description: (NSString*) Description;
- (NSMutableArray *) GetAllDecks;
-(NSMutableArray *) GetDeck: (int) DeckID;
-(NSMutableArray *) GetAllCardsFromDeck: (int) DeckID;
-(bool) CreateKanji: (int) deckId Kanji: (NSMutableArray*) kanjiInfo;
-(NSMutableArray *) GetDeckOptions: (int) DeckID;
-(bool) CreateOptions: (int) DeckId;
-(bool) UpdateOption: (int) DeckID Option: (NSString*) option OptionValue: (NSString*) optionValue;
-(NSMutableArray*) ChooseNewKanjis: (int) DeckId Limit: (int) Limit;
-(bool) UpdateDeckDueDate: (int) DeckID DueDate: (NSString*) DueDate;
-(bool) UpdateKanjiDueDate: (int) CardID DueDate: (NSString*) DueDate;
-(NSMutableArray*) GetDueKanjis: (int) DeckId;
-(bool) UpdateCardStatus: (int) CardId DueDate: (NSString*) DueDate Quality: (int) Quality Interval: (int) Interval EaseFactor: (float) EaseFactor Repetitions: (int) Repetition;
-(bool) UpdateDeck: (int) DeckID DeckName: (NSString*) deckName DeckDescription: description;
-(bool) deleteDeck: (int) ID;
-(bool) deleteCard: (int) ID;
-(int) GetLastInsertedID;
-(int) GetTotalKanjisInDeck: (int) DeckId;
-(int) GetTotalKanjisStuided: (int) DeckId;

@end


NS_ASSUME_NONNULL_END
