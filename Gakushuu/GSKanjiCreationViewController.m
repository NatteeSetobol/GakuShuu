//
//  KanjiCreation.m
//  Gakushuu
//
//  Created by Popcorn on 2/10/22.
//

#import "GSKanjiCreationViewController.h"

@interface GSKanjiCreationViewController ()

@end

@implementation GSKanjiCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ScrollView.contentSize  = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 280);
    
   // _ScrollView.delaysContentTouches = NO;
    _ScrollView.canCancelContentTouches = NO;
}

-(IBAction) CreateKanji: (id) sender
{
    KanjiDatabase *KDatabase = NULL;
    NSMutableArray *Values = [[NSMutableArray alloc] init];
    
    KDatabase = [KanjiDatabase GetInstance];

    [Values addObject:@"0"];
    [Values addObject: [NSString stringWithFormat:@"%i", DeckId]];
    [Values addObject:_KanjField.text];
    [Values addObject:_DesciptionField.text];
    [Values addObject:_KunField.text];
    [Values addObject:_OnField.text];
    [Values addObject:_StoryField.text];
    [Values addObject:@"0"];
    [Values addObject:@"0"];
    [Values addObject:@"0"];
    [Values addObject:@"0"];
    [Values addObject:@"0"];
    [Values addObject:@"0"];
    
    [KDatabase CreateKanji: DeckId Kanji:Values];
    
    [self dismissViewControllerAnimated:true completion:^{
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CardCreationDismissed"
         object:nil userInfo:nil];
         
         
    }];
    
}
-(IBAction) Cancel: (id) sender
{
    [self dismissViewControllerAnimated:true completion:^{
    }];
}

@end
