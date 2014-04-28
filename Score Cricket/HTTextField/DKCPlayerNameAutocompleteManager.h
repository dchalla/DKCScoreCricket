//
//  DKCPlayerNameAutocompleteManager
//
//
//  Created by Dinesh Challa on 12/6/12.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

@interface DKCPlayerNameAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (DKCPlayerNameAutocompleteManager *)sharedManager;

@end
