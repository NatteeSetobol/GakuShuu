//
//  StudyFinished.m
//  Gakushuu
//
//  Created by Popcorn on 2/23/22.
//

#import "GSStudyFinishedViewModal.h"

@interface GSStudyFinishedViewModal ()

@end

@implementation GSStudyFinishedViewModal

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction) Dismissed: (id) sender
{
    [self SendDimissMessage];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self SendDimissMessage];
}

-(void) SendDimissMessage
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    NSMutableArray *SavedOptionRow = NULL;
    NSMutableDictionary *SaveOption= NULL;
    NSNumber *reminderTime = NULL;;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    SavedOptionRow = [KanjiDatabaseIns GetDeckOptions:DeckId];
    SaveOption = [SavedOptionRow objectAtIndex: 0];
    
    reminderTime = [SaveOption objectForKey:@"remind"];
    
    if (reminderTime > 0)
    {
        float reminderTimeInSec = 0;
        // Create the notification content
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Gakushuu";
        content.body = @"it's time to study!";
        
        UNNotificationSound *sound = [UNNotificationSound defaultSound];
        content.sound = sound;
        
        reminderTimeInSec = 60 * [reminderTime intValue];
         
        
        // Create the repeating notification trigger every 30 minutes
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:reminderTimeInSec repeats:NO]; // 1800 seconds = 30 minutes
        
        // Create the notification request
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"YourNotificationIdentifier" content:content trigger:trigger];
        
        // Add the request to the notification center
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Notification scheduled successfully");
            } else {
                NSLog(@"Notification scheduled Failed %@", [error localizedDescription] );
            }
        }];
        
    } else {
        NSLog(@"Timer is off!");
    }
    
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"StudyDismissed"
         object:nil userInfo:nil];
    }];
}
@end
