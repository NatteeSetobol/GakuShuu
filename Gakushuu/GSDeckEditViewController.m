//
//  DeckEdit.m
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import "GSDeckEditViewController.h"

@interface GSDeckEditViewController ()

@end

@implementation GSDeckEditViewController

@synthesize CardTable,Cards,KanjiCreationButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KanjiDatabase *KanjiDatabaseIns = NULL;
    
    Cards = [[NSMutableArray alloc] init];
    
    CardTable.delegate = self;
    CardTable.dataSource = self;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    Cards = [KanjiDatabaseIns GetAllCardsFromDeck:DeckId];
    
    KanjiCreationButton.target = self;
    KanjiCreationButton.action = @selector(KanjiNewCreation:);
    
    addByDictionary.target = self;
    addByDictionary.action = @selector(addByDic:);
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(CardCreationDismissed  )
     name:@"CardCreationDismissed"
     object:nil];
    
}

-(IBAction) addByDic:(id)sender
{
    //DictionaryModal
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSSearchDictionaryModal* KanjiSearch = [storyboard instantiateViewControllerWithIdentifier:@"SearchDictionary"];
    
    KanjiSearch->DeckId = DeckId;
    
    KanjiSearch.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiSearch animated:true completion:^{

    }];
}

-(IBAction) KanjiNewCreation: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSKanjiCreationViewController* KanjiCreationView = [storyboard instantiateViewControllerWithIdentifier:@"KanjiCreation"];
    
    KanjiCreationView->DeckId = DeckId;
    
    KanjiCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiCreationView animated:true completion:^{

    }];
}









-(void) CardCreationDismissed
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    Cards = [KanjiDatabaseIns GetAllCardsFromDeck:DeckId];
    
    [CardTable reloadData];

}

// NOTES(): TABLE DELEGATIONS -============

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString *indexing = [[NSString alloc] initWithFormat:@"index%li", indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indexing];
    
    NSMutableDictionary *CardRow = [Cards objectAtIndex:indexPath.row];
    NSString *Kanji = [CardRow objectForKey:@"kanji"];
    NSNumber *kanjiID = [CardRow objectForKey:@"id"];
    
    
    if (cell == nil)
    {
        //NSMutableDictionary *cellTitle = NULL;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeClose];
        deleteButton.frame = CGRectMake(cell.frame.size.width-30, (cell.frame.size.height/2)-5,deleteButton.frame.size.width, deleteButton.frame.size.height);
        cell.tag = [kanjiID intValue];
        deleteButton.tag = [kanjiID intValue];
        
        [deleteButton addTarget:self action:@selector(showDeletionView:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:deleteButton];
        

        
    }
    cell.tag = [kanjiID intValue];
    cell.textLabel.text = Kanji;


    
    return cell;
}

-(void) showDeletionView: (id) sender
{
    UIButton *cell  = (UIButton*) sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSDeleteModalView* deleteModalView = [storyboard instantiateViewControllerWithIdentifier:@"DeleteModalView"];
    deleteModalView.deckID = -1;
    deleteModalView.cardID = (int) cell.tag;
    
    NSLog(@"Tag: %i", (int) deleteModalView.cardID);
    
    [self presentViewController:deleteModalView animated:true completion:^{
        
        [deleteModalView.Description setText:@"This card will be deleted. You can not undo this."];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deleteDismissed  )
         name:@"deleteCreationDismissed"
         object:nil];
    }];
}

-(void) deleteDismissed
{
    [self CardCreationDismissed];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [Cards count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end
