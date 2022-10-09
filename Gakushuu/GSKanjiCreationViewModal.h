//
//  KanjiCreation.h
//  Gakushuu
//
//  Created by Popcorn on 2/10/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"

NS_ASSUME_NONNULL_BEGIN

enum { KANJI, KUN, ON,STORY, DESCRIPTION, SPACING };

@interface GSKanjiCreationViewModal : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    @public int DeckId;
   // @public IBOutlet UITextField *KanjField;
    @public UITextField *KanjField;
    @public IBOutlet UITextField *KunField;
    @public  UITextField *OnField;
    @public IBOutlet UITextView *DesciptionField;
    @public UIButton *submitButton;

    IBOutlet UITableView *table;
    NSMutableArray *fields;
}
@property (nonatomic) UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *fields;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
//@property (strong, nonatomic) IBOutlet UITextField *KanjField;
@property (strong) UITextField *KanjField;

@property (strong, nonatomic) IBOutlet UITextField *KunField;
@property (strong, nonatomic)  UITextField *OnField;
@property (strong, nonatomic) IBOutlet UITextView *DesciptionField;
@property (strong, nonatomic)  UITextView *StoryField;

-(IBAction) CreateKanji: (id) sender;
-(IBAction) Cancel: (id) sender;

@end

NS_ASSUME_NONNULL_END
