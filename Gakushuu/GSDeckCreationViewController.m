//
//  DeckCreation.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "GSDeckCreationViewController.h"

@interface GSDeckCreationViewController ()

@end

@implementation GSDeckCreationViewController
@synthesize selectionCallback,DescriptionField,DeckField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (DeckId == -1)
    {
        [_CreateDeckButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    

    } else {
        [_CreateDeckButton setTitle:@"Update" forState:UIControlStateNormal];
        [_CreateDeckButton addTarget:self action:@selector(updateDeck:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_CreateCancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction) updateDeck: (id) sender
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    [KanjiDatabaseIns UpdateDeck:DeckId DeckName:self.DeckField.text DeckDescription:self.DescriptionField.text];
    [self dismissViewControllerAnimated:true completion:^{
       [self selectionCallback];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DeckCreationDismissed"
         object:nil userInfo:nil];
    }];
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
