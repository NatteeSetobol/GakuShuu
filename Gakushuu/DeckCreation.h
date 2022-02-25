//
//  DeckCreation.h
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"
NS_ASSUME_NONNULL_BEGIN



@interface DeckCreation : UIViewController
{
    id selectionCallback;
}

@property (atomic, strong) id selectionCallback;
@property (strong, nonatomic) IBOutlet UIButton *CreateDeckButton;
@property (strong, nonatomic) IBOutlet UIButton *CreateCancelButton;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionField;
@property (strong, nonatomic) IBOutlet UITextField *DeckField;


@end

NS_ASSUME_NONNULL_END
