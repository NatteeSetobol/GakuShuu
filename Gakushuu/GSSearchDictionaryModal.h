//
//  GSSearchDictionaryModal.h
//  Gakushuu
//
//  Created by Popcorn on 5/10/22.
//

#import <UIKit/UIKit.h>
#import "GSKanjiCreationViewModal.h"
#include "libpop/required/nix.hpp"
#include "libpop/required/memory.hpp"
#include "libpop/stringz.hpp"
#include "libpop/marray.hpp"
#include "libpop/bucket.hpp"
#include "libpop/queue.hpp"
#import "libpop/htmlparser.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSSearchDictionaryModal : UIViewController <UITableViewDelegate, UITableViewDelegate, UISearchBarDelegate>
{
    @public int DeckId;

    IBOutlet UISearchBar *SearchBar;
    NSMutableArray *searchResult;
}

@property (strong, nonatomic) IBOutlet UITableView *ResultTable;
@property (strong, nonatomic) NSMutableArray *searchResult;

@end

NS_ASSUME_NONNULL_END
