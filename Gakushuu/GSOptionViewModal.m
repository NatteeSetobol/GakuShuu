//
//  OptionView.m
//  Gakushuu
//
//  Created by Popcorn on 2/11/22.
//

#import "GSOptionViewModal.h"

@interface GSOptionViewModal ()

@end

@implementation GSOptionViewModal

@synthesize  OptionArray, KDatabase;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OptionArray = [[NSMutableArray alloc] init];
    
    [_OptionTable setUserInteractionEnabled:true];

    _OptionTable.allowsSelection = false;
    _OptionTable.dataSource = self;
    _OptionTable.delegate = self;
    
    [OptionArray addObject:@"DeckOptions"];
    [OptionArray addObject:@"TimerOptions"];
    [OptionArray addObject:@"ReminderOptions"];


    
    KDatabase = [KanjiDatabase GetInstance];
}



// NOTES(): TABLE DELEGATIONS -============

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [OptionArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat aspectRatio = 1.0f;//350.0f/620.0f;
    
    switch(indexPath.row)
    {
        case DECK_OPTIONS:
        {
            return 230;
            break;
        }

    }
    
    return 230;//aspectRatio * [UIScreen mainScreen].bounds.size.height;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString *indexing = [[NSString alloc] initWithFormat:@"index%li", indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indexing];
        
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
        
        UILabel *mainLabel = NULL;
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [mainLabel setBackgroundColor:[UIColor redColor]];
        [mainLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
        
        switch (indexPath.row)
        {
            case DECK_OPTIONS:
            {
                UILabel *DailyKanjiAdd = NULL;
                NSMutableArray *dailyKanjiAddArray=NULL;
                UISegmentedControl *dailyKanjiSegControl=NULL;
               // UILabel *deckTimer=NULL;
                UILabel *randomKanjiLabel=NULL;
                UISwitch *RandomKanjiSwitch=NULL;
                //NSArray *deckTimerArray=NULL;
                //UISegmentedControl *deckTimerSegControl=NULL;
                NSMutableArray *SavedOptionRow = NULL;
                NSMutableDictionary *SaveOption= NULL;
                NSNumber *KanjiPerDay;
                //NSNumber *TimerInMins;
                NSNumber *RandomKanji;
                
    
                SavedOptionRow = [KDatabase GetDeckOptions:DeckId];
                SaveOption = [SavedOptionRow objectAtIndex: 0];
                
                
                
                KanjiPerDay = [SaveOption objectForKey:@"kanjiperday"];
                RandomKanji = [SaveOption objectForKey:@"randomkanji"];

                
                DailyKanjiAdd = [[UILabel alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];
                
                dailyKanjiAddArray = [[NSMutableArray alloc] initWithObjects:@"1",@"5",@"10",@"30",@"50",@"100", nil];
                
                dailyKanjiSegControl = [[UISegmentedControl alloc] initWithItems:dailyKanjiAddArray];
                
               // deckTimer = [[UILabel alloc] initWithFrame:CGRectMake(15,115,self.view.frame.size.width,30)];
                
              //  deckTimerArray = [NSArray arrayWithObjects:@"Off",@"5 mins",@"10 mins", @"15 mins", @"30 mins", nil];
                
                //deckTimerSegControl = [[UISegmentedControl alloc] initWithItems:deckTimerArray];
                
                randomKanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,115,self.view.frame.size.width,30)];
                
                RandomKanjiSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(15, 145, 120, 120)];
                

                [DailyKanjiAdd setFont:[UIFont fontWithName:@"Courier" size:15]];
                [DailyKanjiAdd setText:@"Kanji Added Per day:"];
                [cell.contentView addSubview: DailyKanjiAdd];
                

                dailyKanjiSegControl.frame = CGRectMake(15, 80, self.view.frame.size.width-20, 30);
                
                
                [dailyKanjiSegControl setUserInteractionEnabled:true];
                [dailyKanjiSegControl setEnabled:true];

               [dailyKanjiSegControl addTarget:self action:@selector(AddKanjiSegmentChangeViewValueChanged:) forControlEvents:UIControlEventValueChanged];

                
                switch ([KanjiPerDay intValue])
                {
                    case 1:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:0];
                        break;
                    }
                    case 5:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:1];
                        break;
                    }
                    case 10:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:2];
                        break;
                    }
                    case 30:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:3];
                        break;
                    }
                    case 50:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:4];
                        break;
                    }
                    case 100:
                    {
                        [dailyKanjiSegControl setSelectedSegmentIndex:5];
                        break;
                    }
                }
                
                [cell.contentView addSubview:dailyKanjiSegControl];
                
   
                
                [randomKanjiLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
                [randomKanjiLabel setText:@"Randomize Kanji:"];
                [cell.contentView addSubview: randomKanjiLabel];
                
                if ([RandomKanji intValue] == 1)
                {
                    [RandomKanjiSwitch setOn: TRUE];
                }
                
                
                 [RandomKanjiSwitch addTarget:self action:@selector(RandomKanjiSwitch:) forControlEvents:UIControlEventValueChanged];
                
                [cell.contentView addSubview:RandomKanjiSwitch];
                
                [mainLabel setText:@"Deck Options"];
                
                
                break;
            }
            case TIMER_OPTIONS:
            {
                UILabel *deckTimer=NULL;
                UILabel *pauseOnAnswerLabel=NULL;

                UISegmentedControl *deckTimerSegControl=NULL;
                NSNumber *TimerInMins;
                NSArray *deckTimerArray = NULL;
                NSMutableArray *SavedOptionRow = NULL;
                NSMutableDictionary *SaveOption= NULL;
                UISwitch *pauseOnAnswerSwitch = NULL;
                NSString *pauseOn = NULL;
                
    
                SavedOptionRow = [KDatabase GetDeckOptions:DeckId];
                SaveOption = [SavedOptionRow objectAtIndex: 0];

                TimerInMins = [SaveOption objectForKey:@"timerinmin"];
                pauseOn = [SaveOption objectForKey:@"pause"];

                
                deckTimerArray = [NSArray arrayWithObjects:@"Off",@"5 mins",@"10 mins", @"15 mins", @"30 mins", nil];

                deckTimer = [[UILabel alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];
                deckTimerSegControl = [[UISegmentedControl alloc] initWithItems:deckTimerArray];

                [deckTimer setFont:[UIFont fontWithName:@"Courier" size:15]];
                [deckTimer setText:@"Deck Timer:"];
                [cell.contentView addSubview: deckTimer];
                
                pauseOnAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, self.view.frame.size.width,30 )];
                [pauseOnAnswerLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
                [pauseOnAnswerLabel setText:@"Pause on Answer"];
                [cell.contentView addSubview: pauseOnAnswerLabel];
                
                pauseOnAnswerSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(15, 155, 120, 120)];
                if ([pauseOn isEqualToString:@"true"])
                {
                    [pauseOnAnswerSwitch  setOn:true];
                }
                [pauseOnAnswerSwitch addTarget:self action:@selector(handlePauseSwitch:) forControlEvents:UIControlEventValueChanged];
                
                [cell.contentView addSubview:pauseOnAnswerSwitch];


                deckTimerSegControl.frame = CGRectMake(15, 80, self.view.frame.size.width-20, 30);
                
                
                switch ( [TimerInMins intValue])
                {
                    case 0:
                    {
                        [deckTimerSegControl setSelectedSegmentIndex:0];
                        break;
                    }
                    case 5:
                    {
                        [deckTimerSegControl setSelectedSegmentIndex:1];

                        break;
                    }
                    case 10:
                    {
                        [deckTimerSegControl setSelectedSegmentIndex:2];
                        
                        break;
                    }
                    case 15:
                    {
                        [deckTimerSegControl setSelectedSegmentIndex:3  ];
                        break;
                    }
                    case 30:
                    {
                        [deckTimerSegControl setSelectedSegmentIndex:4  ];
                            
                        break;
                    }
                }
                
                [deckTimerSegControl addTarget:self action:@selector(TimerViewValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:deckTimerSegControl];
                
                [mainLabel setText:@"Timer Options"];
                

                break;
            }
            case REMINDER_OPTIONS:
            {
                UILabel *remindMeSwitchLabel=NULL;
                UISegmentedControl *reminderSegCtl=NULL;
                NSArray *reminderTimeArray = NULL;
                NSMutableArray *SavedOptionRow = NULL;
                NSMutableDictionary *SaveOption= NULL;
                NSNumber *reminderTime = NULL;;

                
                /*Get saved option from the database*/
                SavedOptionRow = [KDatabase GetDeckOptions:DeckId];
                SaveOption = [SavedOptionRow objectAtIndex: 0];
                
                reminderTime = [SaveOption objectForKey:@"remind"];
                
        

                
                /*Add Reminder label*/
                remindMeSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,45,self.view.frame.size.width,30)];

                [remindMeSwitchLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
                [remindMeSwitchLabel setText:@"Remind me to study:"];
                [cell.contentView addSubview: remindMeSwitchLabel];
                
                
                reminderTimeArray = [NSArray arrayWithObjects:@"Off",@"10 mins",@"15 mins", @"30 mins", @"1 hour", nil];
                
                /*Add Segmentd Controller for reminder*/
                reminderSegCtl = [[UISegmentedControl alloc] initWithItems:reminderTimeArray];
                
                reminderSegCtl.frame = CGRectMake(15, 80, self.view.frame.size.width-20, 30);
                [reminderSegCtl addTarget:self action:@selector(ReminderSegmentControllCallback:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:reminderSegCtl];
                
                switch ( [reminderTime intValue])
                {
                    case 0:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:0];
                        break;
                    }
                    case 10:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:1];

                        break;
                    }
                    case 15:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:2];
                        
                        break;
                    }
                    case 30:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:3  ];
                        break;
                    }
                    case 60:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:4  ];
                            
                        break;
                    }
                    default:
                    {
                        [reminderSegCtl setSelectedSegmentIndex:0  ];
                        break;
                    }
                }
                

             
                /*Set Title*/
                [mainLabel setText:@"Reminder"];
                
                
                break;
            }
        }
        
        [cell.contentView addSubview:mainLabel];

        
    }

   // cell.textLabel.text = Deckname;

    return cell;
}

-(IBAction)ReminderSegmentControllCallback:(UISegmentedControl *)SControl
{
    int savedReminder = 0;
    
    switch(SControl.selectedSegmentIndex)
    {
        case 0:
        {
            savedReminder = 0;
            break;
        }
        case 1:
        {
            savedReminder  = 10;
            break;
        }
        case 2:
        {
            savedReminder  = 15;

            break;
        }
        case 3:
        {
            savedReminder  = 30;

            break;
        }
        case 4:
        {
            savedReminder  = 60;
            break;
        }
        default:
        {
            savedReminder = 0;
            break;
        }
    }
    if ([KDatabase UpdateOption:DeckId Option:@"remind" OptionValue:[NSString stringWithFormat:@"%i", savedReminder  ]])
    {
        NSLog(@"Option updated");
    } else {
        NSLog(@"Option update failed");
    }
}

-(IBAction)TimerViewValueChanged:(UISegmentedControl *)SControl
{
    int savedTimerInSecs = 0;
    
    switch(SControl.selectedSegmentIndex)
    {
        case 0:
        {
            savedTimerInSecs = 0;
            break;
        }
        case 1:
        {
            savedTimerInSecs = 5;
            break;
        }
        case 2:
        {
            savedTimerInSecs = 10;

            break;
        }
        case 3:
        {
            savedTimerInSecs = 15;

            break;
        }
        case 4:
        {
            savedTimerInSecs = 30;
            break;
        }
    }
    if ([KDatabase UpdateOption:DeckId Option:@"timerinmin" OptionValue:[NSString stringWithFormat:@"%i", savedTimerInSecs ]])
    {
        NSLog(@"Option updated");
    } else {
        NSLog(@"Option update failed");
    }

}

-(IBAction)AddKanjiSegmentChangeViewValueChanged:(UISegmentedControl *)SControl
{
    int Days = 0;
    switch(SControl.selectedSegmentIndex)
    {
        case 0:
        {
            Days = 1;
            break;
        }
        case 1:
        {
            Days = 5;
            break;
        }
        case 2:
        {
            Days = 10;
            break;
        }
        case 3:
        {
            Days = 30;
            break;
        }
        case 4:
        {
            Days = 50;
            break;
        }
        case 5:
        {
            Days = 100;
            break;
        }
    }
    
    if ([KDatabase UpdateOption:DeckId Option:@"kanjiperday" OptionValue:[NSString stringWithFormat:@"%i", Days  ]])
    {
        NSLog(@"Option updated");
    } else {
        NSLog(@"Option update failed");
    }
}

-(IBAction) handlePauseSwitch:(UISwitch *)Swift
{
    if (Swift.isOn)
    {
        if ([KDatabase UpdateOption:DeckId Option:@"pause" OptionValue:[NSString stringWithFormat:@"\"true\""]])
        {
            NSLog(@"Option updated");
        } else {
            NSLog(@"Option update failed");
        }
    } else {
        if ([KDatabase UpdateOption:DeckId Option:@"pause" OptionValue:[NSString stringWithFormat:@"\"false\""]])
        {
            NSLog(@"Option updated");
        } else {
            NSLog(@"Option update failed");
        }
    }
}

- (void) RandomKanjiSwitch:(UISwitch *)theSwitch
{
    int value = 0;
    if (theSwitch.isOn)
    {
        value = 1;
    } else {
        value = 0;
    }
    if ([KDatabase UpdateOption:DeckId Option:@"randomkanji" OptionValue:[NSString stringWithFormat:@"%i", value  ]])
    {
        NSLog(@"Option updated");
    } else {
        NSLog(@"Option update failed");
    }
}
@end
