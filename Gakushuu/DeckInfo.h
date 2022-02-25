//
//  DeckInfo.h
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "DeckEdit.h"
#import "OptionView.h"
#import "StudyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckInfo : UIViewController
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

- (IBAction)ShowOptions:(id)sender;
- (IBAction) StudyKanji: (id) sender;


@end

NS_ASSUME_NONNULL_END
