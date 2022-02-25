//
//  StudyView.h
//  Gakushuu
//
//  Created by Popcorn on 2/13/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#import "StudyFinished.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudyView : UIViewController <UIGestureRecognizerDelegate>
{
    @public int DeckId;
    UITapGestureRecognizer *doubleTapAction;
    NSMutableArray *KanjisDueDeck;
    NSMutableDictionary *Options;
}
@property (retain, nonatomic) NSMutableDictionary *Options;
@property (retain, nonatomic) NSMutableArray *KanjisDueDeck;
@property (retain, nonatomic) UITapGestureRecognizer *doubleTapAction;
@property (retain, nonatomic) IBOutlet UILabel *KanjiLabel;
@property (retain, nonatomic) IBOutlet UILabel *KunTagLabel;
@property (retain, nonatomic) IBOutlet UILabel *KunLabel;
@property (retain, nonatomic) IBOutlet UILabel *OnTagLabel;
@property (retain, nonatomic) IBOutlet UILabel *OnLabel;
@property (retain, nonatomic) IBOutlet UILabel *DefinitionTagLabel;
@property (retain, nonatomic) IBOutlet UILabel *DefinitionLabel;
@property (retain, nonatomic) IBOutlet UILabel *RatingLabel;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingOne;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingTwo;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingThree;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingFour;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingFive;
@property (retain, nonatomic) IBOutlet UIButton *ButtonRatingSix;


-(id) ShowAnswer: (UIGestureRecognizer*) gesture;

-(void) HideAnswer;

@end

NS_ASSUME_NONNULL_END
