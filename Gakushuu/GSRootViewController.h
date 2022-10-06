//
//  RootViewController.h
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import <UIKit/UIKit.h>
#import "GSDeckCreationViewModal.h"
#import "GSDeckInfoViewController.h"

NS_ASSUME_NONNULL_BEGIN

#define DECK_TABLE_MARGIN 235

@interface GSRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* Decks;
}

@property (strong, atomic) NSMutableArray *Decks;
@property (strong, nonatomic) IBOutlet UITableView *DeckTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AddDeckButton;
@property (strong, nonatomic) IBOutlet UITabBar *ToolBar;

-(void) refreshDeckTable;
-(void) dismissedDeckCreation;

@end

NS_ASSUME_NONNULL_END
