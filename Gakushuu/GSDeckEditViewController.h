//
//  DeckEdit.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "GSKanjiCreationViewController.h"
#import "GSOptionViewController.h"
#import "GSDeleteModalView.h"
#import "GSSearchDictionaryModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSDeckEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
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
