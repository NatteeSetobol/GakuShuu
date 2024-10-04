//
//  StudyFinished.h
//  Gakushuu
//
//  Created by Popcorn on 2/23/22.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "KanjiDatabase.h"


NS_ASSUME_NONNULL_BEGIN

@interface GSStudyFinishedViewModal : UIViewController
{
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *titleLabel;
    @public int DeckId;
}

@property (retain, nonatomic) UILabel *descriptionLabel;
@property (retain, nonatomic) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
