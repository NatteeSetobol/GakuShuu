//
//  KanjiCreation.m
//  Gakushuu
//
//  Created by Popcorn on 2/10/22.
//

#import "GSKanjiCreationViewModal.h"

@interface GSKanjiCreationViewModal ()

@end

@implementation GSKanjiCreationViewModal
@synthesize KanjField, KunField, OnField, DesciptionField,table,fields, StoryField, submitButton;

- (void)viewDidLoad {
   
    [super viewDidLoad];
   /*
    _ScrollView.contentSize  = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 280);
    
   // _ScrollView.delaysContentTouches = NO;
    _ScrollView.canCancelContentTouches = NO;
    */
    
    fields = [[NSMutableArray alloc] init];
    
    table.allowsSelection = false;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    
    [fields addObject:@"Kanji"];
    [fields addObject:@"Kun"];
    [fields addObject:@"On"];
    [fields addObject:@"Story"];
    [fields addObject:@"Description"];
    [fields addObject:@"Spacing"];




}

-(IBAction) CreateKanji: (id) sender
{
    KanjiDatabase *KDatabase = NULL;
    NSMutableArray *Values = [[NSMutableArray alloc] init];
    
    KDatabase = [KanjiDatabase GetInstance];

    [Values addObject:@"0"];
    [Values addObject: [NSString stringWithFormat:@"%i", DeckId]];
    [Values addObject:KanjField.text];
    [Values addObject:DesciptionField.text];
    [Values addObject:KunField.text];
    [Values addObject:OnField.text];
    [Values addObject:StoryField.text];
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

// NOTES(): TABLE DELEGATIONS -============

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [fields count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString *indexing = [[NSString alloc] initWithFormat:@"index%li", indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indexing];
        
    if (cell == nil)
    {
        UILabel *mainLabel = NULL;

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexing];
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 30)];
        [mainLabel setBackgroundColor:[UIColor redColor]];
        [mainLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
        
        switch(indexPath.row)
        {
            case KANJI:
            {
                KanjField = [[UITextField alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];
                [KanjField setTextColor:[UIColor blackColor]];
                [KanjField setBackgroundColor: [UIColor whiteColor]];
                [cell.contentView addSubview:KanjField];
                break;
            }
            case KUN:
            {
                KunField = [[UITextField alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];
                [KunField setTextColor:[UIColor blackColor]];
                [KunField setBackgroundColor: [UIColor whiteColor]];
                [cell.contentView addSubview:KunField];
                break;
            }
            case ON:
            {
                OnField = [[UITextField alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];
                [OnField setTextColor:[UIColor blackColor]];

                [OnField setBackgroundColor: [UIColor whiteColor]];
                [cell.contentView addSubview:OnField];
                break;
            }
            case STORY:
            {
                StoryField = [[UITextView alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width-40,200)];
                [StoryField setTextColor:[UIColor blackColor]];
                [StoryField setBackgroundColor: [UIColor whiteColor]];

                [cell.contentView addSubview:StoryField];
                break;
            }
            case DESCRIPTION:
            {
                DesciptionField = [[UITextView alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width-40,200)];
                [DesciptionField setTextColor:[UIColor blackColor]];
                [DesciptionField setBackgroundColor: [UIColor whiteColor]];

                [cell.contentView addSubview:DesciptionField];
                break;
            }
        }
        if (indexPath.row != SPACING)
        {
            NSString *kanjiTitle = NULL;
            kanjiTitle =  [fields objectAtIndex:indexPath.row];
            [mainLabel setText:kanjiTitle];
        
            [cell.contentView addSubview:mainLabel];
        } else {
            submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            submitButton.frame = CGRectMake(0, 0, 300, 50);
            [submitButton addTarget:NULL action:@selector(CreateKanji:) forControlEvents:UIControlEventTouchUpInside];
            [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
            
            [cell.contentView addSubview:submitButton];
        }
        NSLog(@"created again!");
    }
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CGFloat aspectRatio = 1.0f;//350.0f/620.0f;
    
    switch(indexPath.row)
    {
        case SPACING:
        {
            return 330;
        }
        case DESCRIPTION:
        case STORY:
        {
            return 300;
            break;
        }
        

    }
    
    return 100;//aspectRatio * [UIScreen mainScreen].bounds.size.height;
}
@end
