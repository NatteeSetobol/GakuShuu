//
//  GSDisplayModal.m
//  Gakushuu
//
//  Created by Popcorn on 10/1/22.
//

#import "GSDisplayModal.h"

@interface GSDisplayModal ()

@end


@implementation GSDisplayModal

@synthesize kanjiLabel, kunLabel,meaningLabel,onLabel, card;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *Kanji = NULL;
    NSString *Kun = NULL;
    NSString *Onyomi = NULL;
    NSString *meaning = NULL;
    
    Kanji = [card objectForKey:@"kanji"];
    Kun = [card objectForKey:@"kunyomi"];
    Onyomi = [card objectForKey:@"onyomi"];
    meaning = [card objectForKey:@"meaning"];

    [kanjiLabel setText:Kanji];
    [kunLabel setText:Kun];
    [onLabel setText:meaning];
    [meaningLabel setText:Onyomi];
    [meaningLabel setMultipleTouchEnabled:true];

}


@end
