//
//  DeckCreation.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "GSDeckCreationViewModal.h"
#include "./libpop/required/nix.cpp"
#include "./libpop/required/memory.cpp"
#include "./libpop/stringz.cpp"
#include "./libpop/marray.cpp"
#include "./libpop/JsonParser.cpp"


@interface GSDeckCreationViewModal ()

@end

@implementation GSDeckCreationViewModal
@synthesize selectionCallback,DescriptionField,DeckField, urlField,isAddByLink,errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (DeckId == -1)
    {
        [_CreateDeckButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    

    } else {
        [_CreateDeckButton setTitle:@"Update" forState:UIControlStateNormal];
        [_CreateDeckButton addTarget:self action:@selector(updateDeck:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_CreateCancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    urlField.delegate = self;
    DeckField.delegate = self;
    
}
-(IBAction) updateDeck: (id) sender
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    [KanjiDatabaseIns UpdateDeck:DeckId DeckName:self.DeckField.text DeckDescription:self.DescriptionField.text];
    [self dismissViewControllerAnimated:true completion:^{
       [self selectionCallback];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DeckCreationDismissed"
         object:nil userInfo:nil];
    }];
}

-(IBAction) submit: (id) sender
{
    KanjiDatabase *KanjiDatabaseIns = NULL;
    KanjiDatabaseIns = [KanjiDatabase GetInstance];
    
    if (isAddByLink.isOn)
    {
        NSURL *url = NULL;
        NSURLSession  *urlSession = NULL;
        NSURLRequest *request = NULL;
        NSURLSessionTask *urlSessionTask = NULL;
        
        url = [[NSURL alloc] initWithString:urlField.text];
        urlSession = [NSURLSession sharedSession];
        request = [[NSURLRequest alloc] initWithURL:url];
        
      
        urlSessionTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200)
            {
                char *responseData = (char*) [data bytes];
            
                if (responseData)
                {
                    int dID = -1;

                    Json_Branch jBranch = {};
                
                    JSON_Parse(responseData, &jBranch);
                
                    if (jBranch.subBranch)
                    {
                        if (jBranch.subBranch->head->value)
                        {
                            NSString *deckname = NULL;

                        
                            deckname = [NSString stringWithUTF8String: jBranch.subBranch->head->value];
                    
                            [KanjiDatabaseIns CreateDeck:deckname Description:@"test"];
                        
                            dID = [KanjiDatabaseIns GetLastInsertedID];
                            if (jBranch.subBranch->head->next)
                            {
                                if (StrCmp(jBranch.subBranch->head->next->key, "cards"))
                                {
                                    Json_Branch *cardBranch = NULL;
                                
                                    cardBranch = jBranch.subBranch->head->next->subBranch->head;
                                    if (cardBranch)
                                    {


                                        while (cardBranch)
                                        {
                                        
                                            Json_Branch *entries = NULL;
                                            NSString *kanjiString = @"";
                                            NSString *onString = @"";
                                            NSString *kunString = @"";
                                            NSString *meaningString = @"";

                                            entries = cardBranch->subBranch->head;
                                        
                                            while (entries)
                                            {
                                                if (StrCmp(entries->key,"Kanji"))
                                                {
                                                    kanjiString = [[NSString alloc] initWithUTF8String:entries->value];
                                                }
                                                if (StrCmp(entries->key,"on"))
                                                {
                                                    onString = [[NSString alloc] initWithUTF8String:entries->value];
                                                }
                                                if (StrCmp(entries->key,"kun"))
                                                {
                                                    kunString = [[NSString alloc] initWithUTF8String:entries->value];
                                                }
                                                if (StrCmp(entries->key,"meaning"))
                                                {
                                                    meaningString = [[NSString alloc] initWithUTF8String:entries->value];
                                                }
                                            
                                                entries = entries->next;
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                KanjiDatabase *KDatabase = NULL;
                                                NSMutableArray *Values = [[NSMutableArray alloc] init];
                                        
                                                KDatabase = [KanjiDatabase GetInstance];

                                                [Values addObject:@"0"];
                                                [Values addObject: [NSString stringWithFormat:@"%i", dID ]];
                                                [Values addObject:kanjiString];
                                                [Values addObject:meaningString];
                                                [Values addObject: kunString];
                                                [Values addObject: onString];
                                                [Values addObject:@""];
                                                [Values addObject:@"0"];
                                                [Values addObject:@"0"];
                                                [Values addObject:@"0"];
                                                [Values addObject:@"0"];
                                                [Values addObject:@"0"];
                                                [Values addObject:@"0"];
                                        
                                                [KDatabase CreateKanji: dID Kanji:Values];
                                            });
                                            cardBranch = cardBranch->next;
                                        }
                                    }

                                
                            }
                        }
                    } else {
                        NSLog(@"not a json file!");
                    }
                } else {
                    NSLog(@"no data?");
                }

            }
            } else {
                NSLog(@"error has occured");
            }
    
        }];
        [urlSessionTask resume];
        
        
         
        
    } else {
        [KanjiDatabaseIns CreateDeck:self.DeckField.text Description:self.DescriptionField.text];
    }
    
    [self dismissViewControllerAnimated:true completion:^{
    [self selectionCallback];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DeckCreationDismissed"
     object:nil userInfo:nil];
    }];
}


-(IBAction) AddByDictionary: (id) sender
{
    
}

-(IBAction) cancel: (id) sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
