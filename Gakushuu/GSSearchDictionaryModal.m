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
    [_ResultTable reloadData];
    
    
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
                
                nsKanji = [[NSString alloc] initWithUTF8String:kanjiNoTag];
                
                [dictionary setObject:nsKanji forKey:@"kanji"];
                    
                if (results)
                {
                    [dictionary setObject:results forKey:@"furigana"];
                }
                [dictionary setObject:[NSString stringWithUTF8String:firstMeaning]  forKey:@"meaning"];
                
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indexing];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        label.text = [arrayRow objectForKey:@"kanji"];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.tag = 10;
        [cell addSubview:label];
        
        
        defLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, cell.frame.size.width-150, 150)];
        defLabel.text = [arrayRow objectForKey:@"meaning"];
        [defLabel setNumberOfLines:0];
        [defLabel setTextAlignment:NSTextAlignmentCenter];
        defLabel.tag = 11;
        [cell addSubview:defLabel];
        
    } else {
        for (int i=0; i < cell.subviews.count;i++)
        {
            UIView *oldCell = [cell.subviews objectAtIndex:i];
            switch(oldCell.tag)
            {
                case 10:
                {
                    UILabel *dlabel = NULL;
                    dlabel = (UILabel*) [cell.subviews objectAtIndex:i];
                    dlabel.text =  [arrayRow objectForKey:@"kanji"];
                    break;
                }
                case 11:
                {
                    UILabel *dlabel = NULL;
                    dlabel = (UILabel*) [cell.subviews objectAtIndex:i];
                    dlabel.text = [arrayRow objectForKey:@"meaning"];
                    
                    break;
                }
            }
        }
    }
    
    return cell;
}

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
                }
                FreeHtml(&furiPiecesHTML);
                furiPieces = GetNextElement(&furiPiecesHTML,"span", furigana, TAG);
            }
            if (fullFurigana)
            {
                result = [[NSString alloc] initWithUTF8String:fullFurigana];
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
    GSKanjiCreationViewModal* KanjiCreationView = [storyboard instantiateViewControllerWithIdentifier:@"KanjiCreation"];
    NSMutableDictionary *arrayRow = [searchResult objectAtIndex:indexPath.row];


    KanjiCreationView.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:KanjiCreationView animated:true completion:^{
        KanjiCreationView->DeckId = self->DeckId;
        [KanjiCreationView->KanjField setText:[arrayRow objectForKey:@"kanji"]];
        [KanjiCreationView->KunField setText:[arrayRow objectForKey:@"furigana"]];
        [KanjiCreationView->DesciptionField setText:[arrayRow objectForKey:@"meaning"]];
    }];

}
@end
