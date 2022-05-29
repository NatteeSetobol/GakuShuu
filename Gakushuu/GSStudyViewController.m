//
//  StudyView.m
//  Gakushuu
//
//  Created by Popcorn on 2/13/22.
//

#import "GSStudyViewController.h"

@interface GSStudyViewController ()

@end

@implementation GSStudyViewController

@synthesize doubleTapAction,KanjisDueDeck,Options,totalTime, currentTime,sessionTimer, Timer,isTimerOn,textToVoice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KanjiDatabase *KanjiDatabaseIns = NULL;
    NSMutableArray *DeckInfo = NULL;
    NSMutableDictionary *DeckRow = NULL;
    NSString *DeckDueDate = NULL;
    NSDateFormatter *dateFormatter = NULL;
    NSDate *DueDate = NULL;
    NSDate *Today = NULL;
    NSDate *Tomarrow = NULL;
    NSCalendar* Calender=NULL;
    NSDateFormatter *TomarrowFormatter = NULL;
    NSString *TomarrowString = NULL;
    NSTimeInterval ResultDays;
    NSMutableArray *OptionArray=NULL;
    NSNumber* KanjiLimit=0;
    NSDateComponents* components = NULL;
    NSMutableArray *DueKanji = NULL;
    

    isFlipped = false;
    
    [self HideAnswer];
    [_ButtonRatingOne setTag:5];
    [_ButtonRatingOne addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonRatingTwo setTag:4];
    [_ButtonRatingTwo addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonRatingThree setTag:3];
    [_ButtonRatingThree addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonRatingFour setTag:2];
    [_ButtonRatingFour addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonRatingFive setTag:1];
    [_ButtonRatingFive addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonRatingSix setTag:0];
    [_ButtonRatingSix addTarget:self action:@selector(ButtonRating:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.name = @"kanji";
    [tapGesture addTarget:self action:@selector(handleTap:)];
    
    [_KanjiLabel addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *kunGesture = [[UITapGestureRecognizer alloc] init];
    kunGesture.numberOfTapsRequired = 2;
    kunGesture.name = @"kun";
    [kunGesture addTarget:self action:@selector(handleTap:)];
    [_KunLabel setMultipleTouchEnabled:true];
    [_KunLabel addGestureRecognizer:kunGesture];
    
    
    UITapGestureRecognizer *onGesture = [[UITapGestureRecognizer alloc] init];
    onGesture.numberOfTapsRequired = 2;
    onGesture.name = @"on";
    [onGesture addTarget:self action:@selector(handleTap:)];
    [_OnLabel setMultipleTouchEnabled:true];
    [_OnLabel addGestureRecognizer:onGesture];
    
    KanjisDueDeck = [[NSMutableArray alloc] init];
    
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    OptionArray = [KanjiDatabaseIns GetDeckOptions:DeckId];
    Options = [OptionArray objectAtIndex:0];
    
    KanjiLimit = (NSNumber*)[Options objectForKey:@"kanjiperday"];
    totalTime  = (NSNumber*)[Options objectForKey:@"timerinmin"];
    
    if ([totalTime intValue] == 0)
    {
        isTimerOn = false;
    } else {
        isTimerOn = true;
    }
   // [_Timer setText:[NSString stringWithFormat:@"%@:00", totalTime]];
    
    /*
        1. Get the deck due date from card
        2. if it's not null then check if duedate is less then currentdate or if null
            or else goto 5
        3. Add choose 5 random Kanji from the data that doesn't have a creation date
        4. insert them into the Array
        5.
    */
    DeckInfo = [KanjiDatabaseIns GetDeck: DeckId];
    DeckRow = [DeckInfo objectAtIndex:0];
    
    Today = [NSDate date];
    
    Calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    components = [[NSDateComponents alloc] init];
    [components setDay:1];
    Tomarrow = [Calender dateByAddingComponents:components toDate:Today options:0];
    
    TomarrowFormatter = [[NSDateFormatter alloc] init];
    [TomarrowFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    TomarrowString = [TomarrowFormatter stringFromDate:Tomarrow];

    DeckDueDate = [DeckRow objectForKey:@"nextdue"];
    
    /* NOTES(): Checks Date and compares with next due if the differences between
     next due and today is less than next due date. If due date is less than or equal to today's
     than add x more kanji then change nextdue date to today's date.
    */
    
    
    if ([DeckDueDate isEqualToString:@"NULL"])
    {

        [self AddNewKanjis: KanjiLimit];
        [KanjiDatabaseIns UpdateDeckDueDate: DeckId DueDate: TomarrowString];

    } else {
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        DueDate = [dateFormatter dateFromString:DeckDueDate];
        ResultDays = [DueDate timeIntervalSinceDate: Today];
        
        if ( ResultDays < 10.0f)
        {
            [self AddNewKanjis: KanjiLimit];
            [KanjiDatabaseIns UpdateDeckDueDate: DeckId DueDate: TomarrowString];

        }
    }
    
    //TODO(): Check for Kanjis that are due
    DueKanji = [KanjiDatabaseIns  GetDueKanjis: DeckId];
    
    for (int i=0;i < [DueKanji count]; i++)
    {
        NSMutableDictionary *ExtractedDueKanji = NULL;
        
        ExtractedDueKanji = [DueKanji objectAtIndex:i];
        
        [KanjisDueDeck addObject:ExtractedDueKanji];
    }
    
   // [self ShuffleDeck];
    
    if ([KanjisDueDeck count] > 0)
    {
        NSMutableDictionary *FirstKanji = NULL;
        
        FirstKanji = [KanjisDueDeck objectAtIndex:0];
        
        [self SetNextKanji:FirstKanji];
    } else {
        [self ShowFinishedView];
    }
    
    sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerEnd:) userInfo:nil repeats:true];
}

-(void) ShuffleDeck
{
    srand(time(NULL));
    
    
    for (int i =0; i < 10000;i++)
    {
        int randomCard1 =arc4random_uniform(  [KanjisDueDeck count]-1);
        int randomCard2 =arc4random_uniform(  [KanjisDueDeck count]-1);
        
        [KanjisDueDeck exchangeObjectAtIndex:randomCard1 withObjectAtIndex:randomCard2];


    }
}

-(void) SetNextKanji: (NSMutableDictionary*) KanjiInfo
{
    [_KanjiLabel setText: [KanjiInfo objectForKey:@"kanji"]];
    
    [_KunLabel setText:[KanjiInfo objectForKey:@"kunyomi"]];
    [_OnLabel setText:[KanjiInfo objectForKey:@"onyomi"]];
    [_DefinitionLabel setText:[KanjiInfo objectForKey:@"meaning"]];
}

-(void) AddNewKanjis: (NSNumber*) KanjiLimit
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    NSMutableArray *NewKanji = NULL;


    KanjiDatabaseIns = [KanjiDatabase GetInstance];

    NewKanji = [KanjiDatabaseIns ChooseNewKanjis: DeckId Limit: [KanjiLimit intValue]];
    
    for (int i=0; i < [NewKanji count]; i++)
    {
        NSMutableDictionary  *Kanji = [NewKanji objectAtIndex:i];
        NSNumber *CardId = (NSNumber*) [Kanji objectForKey:@"id"];
        NSDate *Today = NULL;
        bool DidUpdate = false;
        NSDate *Tomarrow = NULL;
        NSCalendar* Calender=NULL;
        NSDateFormatter *TomarrowFormatter = NULL;
        NSString *TomarrowString = NULL;
        NSDateComponents* components = NULL;
        
        Today = [NSDate date];
        
        Calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        components = [[NSDateComponents alloc] init];
        [components setDay:0]; // NOTES(): Change here
        Tomarrow = [Calender dateByAddingComponents:components toDate:Today options:0];
        
        TomarrowFormatter = [[NSDateFormatter alloc] init];
        [TomarrowFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        TomarrowString = [TomarrowFormatter stringFromDate:Tomarrow];

        DidUpdate = [KanjiDatabaseIns UpdateKanjiDueDate: [CardId intValue] DueDate: TomarrowString];
        
        
    }
}

-(IBAction) ButtonRating :(id)sender
{
    UIButton *button = (UIButton*) sender;
    NSMutableDictionary *CurrentKanjiInfo = NULL;
    NSDate *Today;
    NSDate *Tomarrow = NULL;
    NSCalendar* Calender=NULL;
    NSDateFormatter *TomarrowFormatter = NULL;
    NSString *TomarrowString = NULL;
    NSDateComponents* components = NULL;
    KanjiDatabase *KanjiDatabaseIns = NULL;
    int Quality = 0;
    int Interval = 0;
    float EaseFactor = 0;
    int Repetitions = 0;
    int Rating = 0;
    int CardId = 0;
    
    if ([KanjisDueDeck count] > 0)
    {
        CurrentKanjiInfo = [KanjisDueDeck objectAtIndex:0];
        
        CardId = [[CurrentKanjiInfo objectForKey:@"id"] intValue];
        Quality = [[CurrentKanjiInfo objectForKey:@"quality"] intValue];
        Interval = [[CurrentKanjiInfo objectForKey:@"interval"] intValue];
        EaseFactor = [[CurrentKanjiInfo objectForKey:@"easefactor"] floatValue];
        Repetitions =[[CurrentKanjiInfo objectForKey:@"Repetitions"] intValue];
        
        Rating = (int) button.tag;
        if (Rating >= 3)
        {
            switch (Repetitions)
            {
                case 0:
                {
                    Interval = 1;
                    break;
                }
                case 1:
                {
                    Interval = 6;
                    break;
                }
                default:
                {
                    Interval = Interval * EaseFactor;
                    break;
                }
            }
            
            Repetitions += 1;
            EaseFactor += 0.1f  - (5 - Quality) * (0.8 + (5-Quality) * 0.02);
            
        } else {
            Interval = 1;
            Repetitions = 0;
        }
        
        if (EaseFactor < 1.3)
        {
            EaseFactor = 1.3;
        }
        
        Quality = Rating;
        

        //NOTES(): Calculate the new date using the Interval
        Today = [NSDate date];
        
        Calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        components = [[NSDateComponents alloc] init];
        [components setDay:Interval]; // NOTES(): Change here
        Tomarrow = [Calender dateByAddingComponents:components toDate:Today options:0];
        
        TomarrowFormatter = [[NSDateFormatter alloc] init];
        [TomarrowFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        TomarrowString = [TomarrowFormatter stringFromDate:Tomarrow];
   
        if (Rating == 0)
        {
            Interval = 0;
        }

        KanjiDatabaseIns = [KanjiDatabase GetInstance];
        if (Rating != 0)
        {
            if ([KanjiDatabaseIns UpdateCardStatus:CardId DueDate:TomarrowString Quality:Quality Interval:Interval EaseFactor:EaseFactor Repetitions: Repetitions])
            {
                NSLog(@"card updated");
            }
        }
        [KanjisDueDeck removeObject:CurrentKanjiInfo];
        
        // NOTES(): Recycle it back in if it was given a zero rating
        if (Rating == 0)
        {
            [KanjisDueDeck addObject:CurrentKanjiInfo];
        }
        
        if ([KanjisDueDeck count] > 0)
        {
            if ([totalTime intValue] == 0 && isTimerOn)
            {
                [self ShowFinishedView];
            } else {
                NSMutableDictionary *NextKanjiInfo = NULL;
                NextKanjiInfo = [KanjisDueDeck objectAtIndex:0];
    
                [self SetNextKanji: NextKanjiInfo ];
    
                [self HideAnswer];
            
         
            }
                
        
        } else {
            [self ShowFinishedView];
        }
    }
    


}

-(void) ShowFinishedView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSStudyFinishedViewController* StudyFinishedView = [storyboard instantiateViewControllerWithIdentifier:@"StudyFinished"];
    
    
    StudyFinishedView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:StudyFinishedView animated:true completion:^{
        NSLog(@"testing");
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ReturnToMainPage  )
     name:@"StudyDismissed"
     object:nil];
}

-(void) ReturnToMainPage
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:true];
}

-(void) HideAnswer
{
    [_KunTagLabel setHidden:true];
    [_KunLabel setHidden:true];
    [_OnTagLabel setHidden:true];
    [_OnLabel setHidden:true];
    [_DefinitionTagLabel setHidden:true];
    [_DefinitionLabel setHidden:true];
    [_RatingLabel setHidden:true];
    [_ButtonRatingOne setHidden:true];
    [_ButtonRatingTwo setHidden:true];
    [_ButtonRatingThree setHidden:true];
    [_ButtonRatingFour setHidden:true];
    [_ButtonRatingFive setHidden:true];
    [_ButtonRatingSix setHidden:true];
    
    
    doubleTapAction = [[UITapGestureRecognizer alloc] init];
    doubleTapAction.numberOfTapsRequired = 2;
    doubleTapAction.delegate = self;
    [doubleTapAction addTarget:self action:@selector(ShowAnswer:)];
    [self.view addGestureRecognizer:doubleTapAction];
    isFlipped = false;
}

-(id) ShowAnswer: (UIGestureRecognizer*) gesture
{
    isFlipped = true;
    [_KunTagLabel setHidden:false];
    [_KunLabel setHidden:false];
    [_OnTagLabel setHidden:false];
    [_OnLabel setHidden:false];
    [_DefinitionTagLabel setHidden:false];
    [_DefinitionLabel setHidden:false];
    [_RatingLabel setHidden:false];
    [_ButtonRatingOne setHidden:false];
    [_ButtonRatingTwo setHidden:false];
    [_ButtonRatingThree setHidden:false];
    [_ButtonRatingFour setHidden:false];
    [_ButtonRatingFive setHidden:false];
    [_ButtonRatingSix setHidden:false];
    
    [self.view removeGestureRecognizer:doubleTapAction];
    
    return self;
}

-(void)timerEnd:(NSTimer *)timer {
    int mins = 0;
    float secs = 0;
    float remainingTime = 0.0f;

    currentTime = [NSNumber numberWithFloat:[currentTime floatValue] +  [timer timeInterval]];
    
    remainingTime =   ([totalTime intValue] * 60) - [currentTime floatValue];

    if (remainingTime >= 60)
    {
        mins = remainingTime / 60;
        secs = remainingTime- (60 * mins);
    } else {
        secs = remainingTime;
        
        if (secs <= 0)
        {
            [timer invalidate];
            timer = nil;
            totalTime = 0;
           // return ;
        }
    }
    
    if (secs == 60)
    {
        secs = 59;
    }

   
    
    if (secs > 9)
    {
        [Timer setText:[NSString stringWithFormat:@"%i:%.0f", mins, secs ]];
    } else {
        [Timer setText:[NSString stringWithFormat:@"%i:0%.0f", mins, secs ]];   
    }
    
}


- (void) handleTap:(UITapGestureRecognizer *)tap
{
    NSString *text = NULL;
    
    if ([tap.name isEqualToString:@"kanji"])
    {
        text = _KanjiLabel.text;
    } else
    if ([tap.name isEqualToString:@"kun"])
    {
        text = _KunLabel.text;
    }
    if ([tap.name isEqualToString:@"on"])
    {
        text = _OnLabel.text;
    }
    
    if (isFlipped)
    {
        NSLog(@"Touch!");
        textToVoice = [[TextToVoice alloc] initWithText:text];
        
        [textToVoice GetLink];
        
    } else {
        [self ShowAnswer:tap];
    }
}

@end
