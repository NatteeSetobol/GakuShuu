//
//  OptionView.h
//  Gakushuu
//
//  Created by Popcorn on 2/11/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"

NS_ASSUME_NONNULL_BEGIN

enum { DECK_OPTIONS };

@interface OptionView : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *OptionArray;
    KanjiDatabase *KDatabase;
@public int DeckId;
}
@property (strong, nonatomic) KanjiDatabase *KDatabase;
@property (strong, nonatomic) NSMutableArray *OptionArray;
@property (strong, nonatomic) IBOutlet UITableView *OptionTable;

@end

NS_ASSUME_NONNULL_END
