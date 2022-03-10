//
//  GSDeleteModalView.m
//  Gakushuu
//
//  Created by Popcorn on 3/9/22.
//

#import "GSDeleteModalView.h"

@interface GSDeleteModalView ()

@end

@implementation GSDeleteModalView

@synthesize Description, deckID, cardID;

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(IBAction) delete: (id) sender
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    if ([KanjiDatabaseIns deleteDeck:deckID])
    {

        NSLog(@"deleted!");
    }
    
    [self dismissViewControllerAnimated:true completion:^{
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"deleteCreationDismissed"
         object:nil userInfo:nil];
    }];
}

-(IBAction) closeModal:(id)sender
{
    [self dismissViewControllerAnimated:true completion:^{
        

    }];
}

@end
