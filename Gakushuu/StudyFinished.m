//
//  StudyFinished.m
//  Gakushuu
//
//  Created by Popcorn on 2/23/22.
//

#import "StudyFinished.h"

@interface StudyFinished ()

@end

@implementation StudyFinished

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
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"StudyDismissed"
         object:nil userInfo:nil];
    }];
}
@end
