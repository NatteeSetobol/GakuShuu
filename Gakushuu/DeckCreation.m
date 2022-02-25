//
//  DeckCreation.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "DeckCreation.h"

@interface DeckCreation ()

@end

@implementation DeckCreation
@synthesize selectionCallback;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_CreateDeckButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    [_CreateCancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction) submit: (id) sender
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    [KanjiDatabaseIns CreateDeck:self.DeckField.text Description:self.DescriptionField.text];

    [self dismissViewControllerAnimated:true completion:^{
       [self selectionCallback];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DeckCreationDismissed"
         object:nil userInfo:nil];
    }];
}


-(IBAction) cancel: (id) sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
