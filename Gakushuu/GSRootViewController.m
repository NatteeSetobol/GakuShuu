//
//  RootViewController.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "GSRootViewController.h"

@interface GSRootViewController ()

@end

@implementation GSRootViewController

@synthesize Decks;

- (void)viewDidLoad {
    [super viewDidLoad];
    _DeckTable.delegate = self;
    _DeckTable.dataSource = self;
    _AddDeckButton.target = self;
    _AddDeckButton.action = @selector(addDeck:);
    
    CGRect frame = _DeckTable.frame;
    frame.size.height = _DeckTable.frame.size.height - _ToolBar.frame.size.height - DECK_TABLE_MARGIN ;
    _DeckTable.frame = frame;
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [self refreshDeckTable];
}

-(void) viewDidAppear:(BOOL)animated
{

}

-(void) refreshDeckTable
{
        
    dispatch_queue_t getDeckQueue = dispatch_queue_create("GetDeck", NULL);
     dispatch_async(getDeckQueue, ^{
         KanjiDatabase *KanjiDatabaseIns = NULL;
         KanjiDatabaseIns = [KanjiDatabase GetInstance];

         self.Decks = [KanjiDatabaseIns GetAllDecks];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.DeckTable reloadData];
         });
     });
   
}

-(IBAction) addDeck: (id) object
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeckCreationViewModal* DeckCreationView = [storyboard instantiateViewControllerWithIdentifier:@"DeckCreation"];
    DeckCreationView->DeckId = -1;
    
    DeckCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:DeckCreationView animated:true completion:^{

    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dismissedDeckCreation  )
     name:@"DeckCreationDismissed"
     object:nil];
}


-(void) dismissedDeckCreation
{
    [self refreshDeckTable];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// NOTES(): TABLE DELEGATIONS -============

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString *indexing = [[NSString alloc] initWithFormat:@"index%li", indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indexing];
    
    NSMutableDictionary *DeckRow = [Decks objectAtIndex:indexPath.row];
    NSString *Deckname = [DeckRow objectForKey:@"name"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexing];
    }

    cell.textLabel.text = Deckname;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [Decks count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeckInfoViewController* DeckInfoView = [storyboard instantiateViewControllerWithIdentifier:@"DeckInfo"];
        
    NSMutableDictionary *DeckRow = [Decks objectAtIndex:indexPath.row];
    NSNumber *DeckID = [DeckRow objectForKey:@"id"];

    
    DeckInfoView->DeckId = [DeckID intValue];
    [self.navigationController pushViewController:DeckInfoView animated: true];

}



@end
