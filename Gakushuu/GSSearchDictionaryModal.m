    //
//  GSSearchDictionaryModal.m
//  Gakushuu
//
//  Created by Popcorn on 5/10/22.
//

#import "GSSearchDictionaryModal.h"
#include "./libpop/bucket.cpp"
#include "./libpop/queue.cpp"
#include "./libpop/htmlparser.cpp"

@interface GSSearchDictionaryModal ()

@end

@implementation GSSearchDictionaryModal
@synthesize searchResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    _ResultTable.delegate = self;
    _ResultTable.dataSource = self;
    SearchBar.delegate = self;
    
    searchResult = [[NSMutableArray alloc] init];
    [_ResultTable setUserInteractionEnabled:true];
    [_ResultTable setMultipleTouchEnabled:true];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self SearchDictionary:searchBar.text];
    [SearchBar resignFirstResponder];
}

- (void) SearchDictionary: (NSString *) searchQuery
{
    NSMutableURLRequest *request=NULL;
    NSURL *nsurl = NULL;
    NSURLSession *session = NULL;
    NSString *urlString = NULL;
    NSString *urlEncodeString = NULL;
    
    [searchResult removeAllObjects];
    
    urlEncodeString = [searchQuery stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    urlString = [NSString stringWithFormat:@"https://jisho.org/search/%@", urlEncodeString ];
    
    nsurl = [NSURL URLWithString:urlString];
    
    request=[NSMutableURLRequest requestWithURL:nsurl];
    
    session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                 completionHandler:^(NSData *data,
                                     NSURLResponse *response,
                                     NSError *error) {
        

    
        char *resultData = (char*) [data bytes];
        char *mainResults = NULL;
        html mainResultHtml = {};
        
        
        
        mainResults = GetNextElement(&mainResultHtml, "main_results", resultData, CLASS);
        
        if (mainResults)
        {
            char *conceptLightClearFix = NULL;
            html conceptLightClearFixHtml = {};
            
            conceptLightClearFix = GetNextElement(&conceptLightClearFixHtml, "concept_light clearfix", mainResults, CLASS);
            
            while (conceptLightClearFixHtml.element.isFound)
            {
                char* furigana = NULL;
                char* kanji = NULL;
                NSString *results = NULL;
                char* kanjiNoTag = NULL;
                char *trimSpaces = NULL;
                char *firstMeaning = NULL;
                NSString *nsKanji = NULL;
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                
                furigana = [self GetFurigana: conceptLightClearFix];
                kanji = [self GetKanji: conceptLightClearFix];
                
                firstMeaning = [self GetDefinition:conceptLightClearFix];
                if (kanji && furigana)
                {
                results = [self GetFullFurigana:furigana Kanji:kanji];
                trimSpaces =S32TrimSpaces(kanji);
                kanjiNoTag = RemoveHTMLTags(trimSpaces);
                
                //NSLog(@"|%s|", trimSpaces);
                nsKanji = [[NSString alloc] initWithUTF8String:kanjiNoTag];
                
                [dictionary setObject:nsKanji forKey:@"kanji"];
                    
                if (results)
                {
                    [dictionary setObject:results forKey:@"furigana"];
                }
                [dictionary setObject:[NSString stringWithUTF8String:firstMeaning]  forKey:@"meaning"];

               // NSLog(@"%s", firstMeaning);
                
                [self.searchResult addObject:dictionary];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.ResultTable reloadData];
                });
                }

                FreeHtml(&conceptLightClearFixHtml);
                
                conceptLightClearFix = GetNextElement(&conceptLightClearFixHtml, "concept_light clearfix", mainResults, CLASS);
        
            }

        }
                
        FreeHtml(&mainResultHtml);

    }] resume];
    
}

-(char*) GetDefinition: (char*) html
{
    s32 *results = NULL;
    s32 *meaningsWrapping = NULL;
    s32 *wordType = NULL;
    struct html meaningsWrappingHtml = {};
    struct html wordTypeHtml = {};
    
    
    meaningsWrapping = GetNextElement(&meaningsWrappingHtml, "meanings-wrapper", html, CLASS);

    if (meaningsWrapping)
    {
        wordType = GetNextElement(&wordTypeHtml, "meaning-meaning",meaningsWrapping, CLASS );
        
        if (wordType)
        {
            results = S32(wordType);
        }
        FreeHtml(&wordTypeHtml);

    }
    
    FreeHtml(&meaningsWrappingHtml);

    return results;
}

- (char*) GetFurigana: (char *) html
{
    char *results = NULL;
    char *furiganaText = NULL;
    struct html furiganaHtml = {};
    
    furiganaText = GetNextElement(&furiganaHtml, "furigana", html, CLASS);
    
    if (furiganaText)
    {
        results = S32(furiganaText);
    }
    
    FreeHtml(&furiganaHtml);
    
    if (furiganaText)
    {
        Free(furiganaText);
        furiganaText=NULL;
    }
    return results;
}

- (char*) GetKanji: (char *) html
{
    char *results = NULL;
    char *kanjiText = NULL;
    struct html kanjiHtml = {};
    
    kanjiText = GetNextElement(&kanjiHtml, "text", html, CLASS);
    
    if (kanjiText)
    {
        results = S32(kanjiText);
    }
    
    Free(kanjiText);
    kanjiText = NULL;
    
    return results;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString *indexing = [[NSString alloc] initWithFormat:@"index%li", indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indexing];
    UILabel *label = NULL;
    UILabel *defLabel = NULL;
        NSMutableDictionary *arrayRow = [searchResult objectAtIndex:indexPath.row];

    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        label.text = [arrayRow objectForKey:@"kanji"];
        //[label setBackgroundColor:[UIColor redColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:label];
        
        
        defLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, cell.frame.size.width-150, 150)];
        defLabel.text = [arrayRow objectForKey:@"meaning"];
       // [defLabel setBackgroundColor:[UIColor greenColor]];
        [defLabel setNumberOfLines:0];
        [defLabel setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:defLabel];
        /*
        addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addButton.frame = CGRectMake(cell.frame.size.width-30 , 0, 100, 100);
        [addButton addTarget:self action: @selector(AddToDictionary:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTag:indexPath.row];
        [addButton setUserInteractionEnabled:true];
        [addButton setMultipleTouchEnabled:true];
        [cell addSubview:addButton];
         */
        
    }

    return cell;
}
/*
-(IBAction) AddToDictionary: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSKanjiCreationViewController* KanjiCreationView = [storyboard instantiateViewControllerWithIdentifier:@"KanjiCreation"];
    
    KanjiCreationView->DeckId = DeckId;
    
    KanjiCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiCreationView animated:true completion:^{

    }];
    
    
}
 */

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
   return [searchResult count];
}

-(NSString *) GetFullFurigana: (s32*) furigana Kanji: (s32*) kanji
{
    /*
     <span class="kanji-1-up kanji">た</span><span></span><span class="kanji-2-up kanji">もの</span><span class="kanji-1-up kanji">や</span>
     */
    
    /*
     食<span>べ</span>物屋
     */
  //  NSLog(@"%s", furigana);
   // NSLog(@"%s", kanji);
    
    NSString *result = NULL;

    if (furigana)
    {
        if (kanji)
        {
            s32 *furiPieces = NULL;
            s32 *kanjiFuriPieces = NULL;
            struct html furiPiecesHTML = {};
            struct html kanjiFuriPiecesHTML = {};
            s32 *fullFurigana = NULL;
            
            
            furiPieces = GetNextElement(&furiPiecesHTML,"span", furigana, TAG);
            
            while (furiPiecesHTML.element.isFound)
            {
                if (StrCmp(furiPieces, "") == false)
                {
                     if (fullFurigana)
                     {
                         s32 *temp = fullFurigana;
                         fullFurigana = CS32Cat(2, temp, furiPieces);
                         
                         if (temp)
                         {
                             Free(temp);
                             temp=NULL;
                         }
                     } else {
                         fullFurigana = S32(furiPieces);
                     }
                    //fullFurigana = [NSString stringWithFormat:@"%@%@", fullFurigana, [NSString stringWithCString:furiPieces encoding:NSUTF16StringEncoding] ];
                } else {
                    kanjiFuriPieces = GetNextElement(&kanjiFuriPiecesHTML, "span", kanji, TAG);
                    
                    if (fullFurigana)
                    {
                        if (kanjiFuriPieces)
                        {
                            s32 *temp = fullFurigana;
                            fullFurigana = CS32Cat(2, temp, kanjiFuriPieces);
                        
                            if (temp)
                            {
                                Free(temp);
                                temp=NULL;
                            }
                        }
                    } else {
                        if (kanjiFuriPieces)
                        {
                            fullFurigana = S32(kanjiFuriPieces);
                        }
                    }
                    
                    //fullFurigana = [NSString stringWithFormat:@"%@%@", fullFurigana, [NSString stringWithCString:kanjiFuriPieces encoding:NSUTF16StringEncoding] ];

                    //FreeHtml(&kanjiFuriPiecesHTML);
                }
                FreeHtml(&furiPiecesHTML);
                furiPieces = GetNextElement(&furiPiecesHTML,"span", furigana, TAG);
            }
            if (fullFurigana)
            {
                result = [[NSString alloc] initWithUTF8String:fullFurigana];
                //result = [NSString stringWithCString:fullFurigana encoding:NSUTF8StringEncoding];
            }
        }
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 150;
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GSKanjiCreationViewController* KanjiCreationView = [storyboard instantiateViewControllerWithIdentifier:@"KanjiCreation"];
    NSMutableDictionary *arrayRow = [searchResult objectAtIndex:indexPath.row];

    /*
    [dictionary setObject:nsKanji forKey:@"kanji"];
    [dictionary setObject:results forKey:@"furigana"];
    [dictionary setObject:[NSString stringWithUTF8String:firstMeaning]  forKey:@"meaning"];
    KanjiCreationView->DeckId = DeckId;
    */
    KanjiCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiCreationView animated:true completion:^{
        KanjiCreationView->DeckId = self->DeckId;
        [KanjiCreationView->KanjField setText:[arrayRow objectForKey:@"kanji"]];
        [KanjiCreationView->KunField setText:[arrayRow objectForKey:@"furigana"]];
        [KanjiCreationView->DesciptionField setText:[arrayRow objectForKey:@"meaning"]];



    }];

}
@end
