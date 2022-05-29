//
//  KanjiCreation.h
//  Gakushuu
//
//  Created by Popcorn on 2/10/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSKanjiCreationViewController : UIViewController
{
    @public int DeckId;
    @public IBOutlet UITextField *KanjField;
    @public IBOutlet UITextField *KunField;
    @public IBOutlet UITextField *OnField;
    @public IBOutlet UITextView *DesciptionField;
}
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UITextField *KanjField;
@property (strong, nonatomic) IBOutlet UITextField *KunField;
@property (strong, nonatomic) IBOutlet UITextField *OnField;
@property (strong, nonatomic) IBOutlet UITextView *DesciptionField;
@property (strong, nonatomic) IBOutlet UITextView *StoryField;

-(IBAction) CreateKanji: (id) sender;
-(IBAction) Cancel: (id) sender;

@end

NS_ASSUME_NONNULL_END
