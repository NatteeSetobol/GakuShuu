//
//  DeckEdit.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "KanjiCreation.h"
#import "OptionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckEdit : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
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
