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
    NSMutableArray *kanjiDue = NULL;
    NSString *DeckDueDate = NULL;
    NSDateFormatter *dateFormatter = NULL;
    NSDate *DueDate = NULL;
    NSTimeInterval ResultDays;
    NSDate *Today = NULL;
    NSMutableArray *OptionArray=NULL;
    NSMutableDictionary *Options;
    NSNumber* KanjiLimit=0;
    int totalDue = 0;
    bool newKanji = false;



    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    Deck = [KanjiDatabaseIns GetDeck:DeckId];
    
    OptionArray = [KanjiDatabaseIns GetDeckOptions:DeckId];
    Options = [OptionArray objectAtIndex:0];
    
    KanjiLimit = (NSNumber*)[Options objectForKey:@"kanjiperday"];
    
    DeckRowOne = [Deck objectAtIndex:0];
    [self setTitle:(NSString*) [DeckRowOne objectForKey:@"name"]];
    
    DeckDesciptionString = (NSString*) [DeckRowOne objectForKey:@"description"];
    
    DeckDueDate = [DeckRowOne objectForKey:@"nextdue"];

    
    [DeckDescription setText:DeckDesciptionString];
    
    [EditDeckButton addTarget:self action:@selector(gotoDeckEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [_Study addTarget:self action:@selector(studyKanji:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteDeck:)];
    
    UIBarButtonItem *EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editDeck:)];
    
    deleteButton.style = UIBarButtonItemStylePlain;
    NSArray *barItems = [[NSArray alloc] initWithObjects:deleteButton,EditButton, nil];
    
    self.navigationItem.rightBarButtonItems=barItems;
    
    kanjiDue = [KanjiDatabaseIns GetDueKanjis:DeckId];

    Today = [NSDate date];

    totalDue = (int)[kanjiDue count];
    
    if ([DeckDueDate isEqualToString:@"NULL"])
    {

        totalDue += [KanjiLimit intValue] ;
        newKanji = true;
    } else {
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        DueDate = [dateFormatter dateFromString:DeckDueDate];
        ResultDays = [DueDate timeIntervalSinceDate: Today];
        
        if ( ResultDays < 10.0f)
        {
            totalDue += [KanjiLimit intValue] ;
            
            

        }
        newKanji = true;
    }
    
    if (newKanji && totalDue != 0)
    {
        [_totalKanjiDue setText:[NSString stringWithFormat:@"%i +%i new", totalDue, [KanjiLimit intValue]]];
    } else
    {
        [_totalKanjiDue setText:[NSString stringWithFormat:@"%i", totalDue]];
    }
    [_totalKanjiCountLabel setText:[NSString stringWithFormat:@"%i", [KanjiDatabaseIns GetTotalKanjisInDeck:DeckId]]];
    
    [_studiedLabel setText:[NSString stringWithFormat:@"%i", [KanjiDatabaseIns GetTotalKanjisStuided:DeckId]]];

}

-(void) deleteDeck: (id) sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeleteModalView* deleteModalView = [storyboard instantiateViewControllerWithIdentifier:@"DeleteModalView"];
    deleteModalView.deckID = DeckId;
    
    
    [self presentViewController:deleteModalView animated:true completion:^{
        
        [deleteModalView.Description setText:@"This will delete the deck as well as cards associated with it."];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deleteDismissed  )
         name:@"deleteCreationDismissed"
         object:nil];
    }];
     
}

-(void) deleteDismissed
{
    [self.navigationController popViewControllerAnimated:true];
}

-(void) editDeck: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeckCreationViewController* deckCreationView = [storyboard instantiateViewControllerWithIdentifier:@"DeckCreation"];
    
    deckCreationView->DeckId = DeckId;
    
    deckCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:deckCreationView animated:true completion:^{
        [deckCreationView.DeckField setText: self.title];
        [deckCreationView.DescriptionField setText:self.DeckDescription.text];
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dismissedEditCreation  )
     name:@"DeckCreationDismissed"
     object:nil];
}

-(IBAction) gotoDeckEdit: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeckEditViewController* DeckEditView = [storyboard instantiateViewControllerWithIdentifier:@"DeckEdit"];
    DeckEditView->DeckId = DeckId;
    
    
    [self.navigationController pushViewController:DeckEditView animated:true];
    

}

-(void) dismissedEditCreation
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    NSString *DeckDesciptionString = NULL;
    NSMutableDictionary *DeckRowOne = NULL;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    Deck = [KanjiDatabaseIns GetDeck:DeckId];
    
    DeckRowOne = [Deck objectAtIndex:0];
    [self setTitle:(NSString*) [DeckRowOne objectForKey:@"name"]];
    
    DeckDesciptionString = (NSString*) [DeckRowOne objectForKey:@"description"];
    
    [DeckDescription setText:DeckDesciptionString];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
