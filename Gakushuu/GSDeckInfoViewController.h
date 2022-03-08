//
//  DeckInfo.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "GSDeckEditViewController.h"
#import "GSOptionViewController.h"
#import "GSStudyViewController.h"
#import "GSDeckCreationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSDeckInfoViewController : UIViewController
{
   
    NSMutableArray *Deck;
    IBOutlet UIButton *EditDeckButton;
    IBOutlet UILabel *DeckDescription;
    @public int DeckId;
}
@property (nonatomic) UIButton *EditDeckButton;
@property (strong, nonatomic) UILabel *DeckDescription;
@property (nonatomic) NSMutableArray *Deck;
@property (strong, nonatomic) IBOutlet UIButton *Study;

- (IBAction)showOptions:(id)sender;
- (IBAction) studyKanji: (id) sender;


@end

NS_ASSUME_NONNULL_END
