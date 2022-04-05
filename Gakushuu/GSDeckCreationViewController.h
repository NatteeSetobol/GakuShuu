//
//  DeckCreation.h
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
#include "./libpop2-objc/JsonParser.h"

NS_ASSUME_NONNULL_BEGIN



@interface GSDeckCreationViewController : UIViewController <UITextFieldDelegate>
{
    @public int DeckId;
    id selectionCallback;
    @public UITextField *DeckField;
    UITextView *DescriptionField;
    IBOutlet UITextField *urlField;
    IBOutlet UISwitch *isAddByLink;
    IBOutlet UILabel *errorLabel;
}

@property (atomic, strong) id selectionCallback;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *CreateDeckButton;
@property (strong, nonatomic) IBOutlet UIButton *CreateCancelButton;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionField;
@property (strong, nonatomic) IBOutlet UITextField *DeckField;
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (strong, nonatomic) UISwitch *isAddByLink;


@end

NS_ASSUME_NONNULL_END
