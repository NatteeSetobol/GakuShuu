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
    
    if (deckID != -1)
    {
        if ([KanjiDatabaseIns deleteDeck:deckID])
        {
            NSLog(@"deleted!");
        }
    } else {
        if ([KanjiDatabaseIns deleteCard:cardID])
        {
            NSLog(@"deleted card! %i", cardID);
        }
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
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"deleteCreationDismissed"
         object:nil userInfo:nil];

    }];
}

@end
