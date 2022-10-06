//
//  GSDisplayModal.h
//  Gakushuu
//
//  Created by Popcorn on 10/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSDisplayModal : UIViewController
{
    UILabel *kanjiLabel;
    UILabel *kunLabel;
    UILabel *meaningLabel;
    UILabel *onLabel;
    NSMutableDictionary *card;
}
@property (strong, nonatomic) IBOutlet UILabel *kanjiLabel;
@property (strong, nonatomic) IBOutlet UILabel *onLabel;
@property (strong, nonatomic) IBOutlet UILabel *kunLabel;
@property (strong, nonatomic) IBOutlet UILabel *meaningLabel;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *card;


@end

NS_ASSUME_NONNULL_END
