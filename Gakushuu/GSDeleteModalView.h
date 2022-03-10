//
//  GSDeleteModalView.h
//  Gakushuu
//
//  Created by Popcorn on 3/9/22.
//

#import <UIKit/UIKit.h>
#import "KanjiDatabase.h"


NS_ASSUME_NONNULL_BEGIN

@interface GSDeleteModalView : UIViewController
{
    int cardID;
    int deckID;
    UILabel *Description;
}

@property int deckID;
@property int cardID;

@property (strong, nonatomic) IBOutlet UILabel *Description;

@end

NS_ASSUME_NONNULL_END
