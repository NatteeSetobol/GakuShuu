//
//  DeckInfo.m
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import "DeckInfo.h"

@interface DeckInfo ()

@end

@implementation DeckInfo
@synthesize Deck,DeckDescription,EditDeckButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    KanjiDatabase *KanjiDatabaseIns = NULL;
    NSString *DeckDesciptionString = NULL;
    NSMutableDictionary *DeckRowOne = NULL;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    Deck = [KanjiDatabaseIns GetDeck:DeckId];
    
    DeckRowOne = [Deck objectAtIndex:0];
    [self setTitle:(NSString*) [DeckRowOne objectForKey:@"name"]];
    
    DeckDesciptionString = (NSString*) [DeckRowOne objectForKey:@"description"];
    
    [DeckDescription setText:DeckDesciptionString];
    
    [EditDeckButton addTarget:self action:@selector(GotoDeckEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [_Study addTarget:self action:@selector(StudyKanji:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(IBAction) GotoDeckEdit: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeckEdit* DeckEditView = [storyboard instantiateViewControllerWithIdentifier:@"DeckEdit"];
    DeckEditView->DeckId = DeckId;
    [self.navigationController pushViewController:DeckEditView animated:true];
}

- (IBAction)ShowOptions:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    OptionView* OptionViewInst = [storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    OptionViewInst->DeckId = DeckId;
    
    OptionViewInst.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:OptionViewInst animated:true completion:^{

    }];
}

- (IBAction) StudyKanji: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    StudyView* StudyViewController = [storyboard instantiateViewControllerWithIdentifier:@"StudyViewController"];
    
    StudyViewController->DeckId = DeckId;
    
    [self.navigationController pushViewController:StudyViewController animated:true];
    
}

@end
