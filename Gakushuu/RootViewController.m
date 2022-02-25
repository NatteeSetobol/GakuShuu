//
//  RootViewController.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize Decks;

- (void)viewDidLoad {
    [super viewDidLoad];
    _DeckTable.delegate = self;
    _DeckTable.dataSource = self;
    _AddDeckButton.target = self;
    _AddDeckButton.action = @selector(AddDeck:);
    
    CGRect frame = _DeckTable.frame;
    frame.size.height = _DeckTable.frame.size.height - _ToolBar.frame.size.height - DECK_TABLE_MARGIN ;
    _DeckTable.frame = frame;
}


 - (void)viewWillAppear:(BOOL)animated
{
    [self RefreshDeckTable];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"will did appear");

}

-(void) RefreshDeckTable
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    KanjiDatabaseIns = [KanjiDatabase GetInstance];

    Decks = [KanjiDatabaseIns GetAllDecks];
    
    NSLog(@"%lu", [self.Decks count]);

    [_DeckTable reloadData];
    
   
}

-(IBAction) AddDeck: (id) object
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeckCreation* DeckCreationView = [storyboard instantiateViewControllerWithIdentifier:@"DeckCreation"];
    
    
    DeckCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:DeckCreationView animated:true completion:^{

    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(DeckCreationDismissed  )
     name:@"DeckCreationDismissed"
     object:nil];
}


-(void) DeckCreationDismissed
{
    [self RefreshDeckTable];
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
        //NSMutableDictionary *cellTitle = NULL;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
        


        
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
    DeckInfo* DeckInfoView = [storyboard instantiateViewControllerWithIdentifier:@"DeckInfo"];
        
    NSMutableDictionary *DeckRow = [Decks objectAtIndex:indexPath.row];
    NSNumber *DeckID = [DeckRow objectForKey:@"id"];

    
    DeckInfoView->DeckId = [DeckID intValue];
    [self.navigationController pushViewController:DeckInfoView animated: true];

}



@end
