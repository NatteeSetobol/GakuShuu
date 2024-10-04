//
//  DeckInfo.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "GSDeckEditViewModal.h"
#import "GSOptionViewModal.h"
#import "GSStudyViewController.h"
#import "GSDeckCreationViewModal.h"
#import "GSDeleteModalView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSDeckInfoViewController : UIViewController
{
   
    NSMutableArray *Deck;
    IBOutlet UIButton *EditDeckButton;
    IBOutlet UILabel *DeckDescription;
    __weak IBOutlet UILabel *hasStudyLabel;
@public int DeckId;
}
@property (strong, nonatomic) IBOutlet UILabel *totalKanjiDue;
@property (strong, nonatomic) IBOutlet UILabel *hasStudyLabel;
@property (strong, nonatomic) IBOutlet UILabel *studiedLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalKanjiCountLabel;
@property (nonatomic) UIButton *EditDeckButton;
@property (strong, nonatomic) UILabel *DeckDescription;
@property (nonatomic) NSMutableArray *Deck;
@property (strong, nonatomic) IBOutlet UIButton *Study;

- (IBAction)showOptions:(id)sender;
- (IBAction) studyKanji: (id) sender;


@end

NS_ASSUME_NONNULL_END
