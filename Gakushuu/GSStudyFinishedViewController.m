//
//  StudyFinished.m
//  Gakushuu
//
//  Created by Popcorn on 2/23/22.
//

#import "GSStudyFinishedViewController.h"

@interface GSStudyFinishedViewController ()

@end

@implementation GSStudyFinishedViewController

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
