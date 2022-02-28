//
//  DeckInfo.m
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import "GSDeckInfoViewController.h"

@interface GSDeckInfoViewController ()

@end

@implementation GSDeckInfoViewController
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
    
    [EditDeckButton addTarget:self action:@selector(gotoDeckEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [_Study addTarget:self action:@selector(studyKanji:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(IBAction) gotoDeckEdit: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeckEditViewController* DeckEditView = [storyboard instantiateViewControllerWithIdentifier:@"DeckEdit"];
    DeckEditView->DeckId = DeckId;
    [self.navigationController pushViewController:DeckEditView animated:true];
}

- (IBAction)showOptions:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSOptionViewController* OptionViewInst = [storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    OptionViewInst->DeckId = DeckId;
    
    OptionViewInst.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:OptionViewInst animated:true completion:^{

    }];
}

- (IBAction) studyKanji: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    GSStudyViewController* StudyViewController = [storyboard instantiateViewControllerWithIdentifier:@"StudyViewController"];
    
    StudyViewController->DeckId = DeckId;
    
    [self.navigationController pushViewController:StudyViewController animated:true];
    
}

@end
