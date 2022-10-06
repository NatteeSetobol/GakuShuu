//
//  DeckEdit.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "GSKanjiCreationViewModal.h"
#import "GSOptionViewModal.h"
#import "GSDeleteModalView.h"
#import "GSSearchDictionaryModal.h"
#import "GSDisplayModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSDeckEditViewModal : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIBarButtonItem *addByDictionary;
    UITableView *CardTable;
    NSMutableArray *Cards;
    UIBarButtonItem *KanjiCreationButton;
    @public int DeckId;
}
@property (strong, nonatomic) IBOutlet UITableView *CardTable;
@property (strong, nonatomic) NSMutableArray *Cards;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *KanjiCreationButton;


@end


NS_ASSUME_NONNULL_END
