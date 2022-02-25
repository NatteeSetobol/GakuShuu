//
//  DeckEdit.m
//  Gakushuu
//
//  Created by Popcorn on 2/9/22.
//

#import "DeckEdit.h"

@interface DeckEdit ()

@end

@implementation DeckEdit

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
}

-(IBAction) KanjiNewCreation: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    KanjiCreation* KanjiCreationView = [storyboard instantiateViewControllerWithIdentifier:@"KanjiCreation"];
    
    KanjiCreationView->DeckId = DeckId;
    
    KanjiCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiCreationView animated:true completion:^{

    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(CardCreationDismissed  )
     name:@"CardCreationDismissed"
     object:nil];
    //[self.navigationController pushViewController: KanjiCreationView animated:true];
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
    
    if (cell == nil)
    {
        //NSMutableDictionary *cellTitle = NULL;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
        


        
    }

    cell.textLabel.text = Kanji;

    return cell;
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
