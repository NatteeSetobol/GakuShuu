//
//  TextToVoice.h
//  Gakushuu
//
//  Created by Popcorn on 4/22/22.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

enum TextToVoiceStates  { IDLE, INIT, DOWNLOADING, FINISHED, ERROR };

@interface TextToVoice : UIViewController <AVAudioPlayerDelegate>
{
    NSString *text;
   @public int state;
    AVAudioPlayer *player;
    NSString *cookie;
}

@property (retain) NSString *cookie;
@property (retain) AVAudioPlayer *player;
@property (retain, nonatomic) NSString *text;

- (id) initWithText: (NSString *) text;
- (void) GetLink;
-(void) GetHomePage;

@end

NS_ASSUME_NONNULL_END
