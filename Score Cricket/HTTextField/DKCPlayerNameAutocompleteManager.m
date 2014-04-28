//
//  DKCPlayerNameAutocompleteManager
//
//
//  Created by Dinesh Challa on 12/6/12.
//

#import "DKCPlayerNameAutocompleteManager.h"
#import "DKCPlayersDatasource.h"

static DKCPlayerNameAutocompleteManager *sharedManager;

@implementation DKCPlayerNameAutocompleteManager

+ (DKCPlayerNameAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[DKCPlayerNameAutocompleteManager alloc] init]; });
	return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
	NSArray *componentsString = [prefix componentsSeparatedByString:@","];
	NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSString *playerName = [[DKCPlayersDatasource sharedPlayersDatasource] retrievePlayerNameWithPrefix:prefixLastComponent];
	if (prefixLastComponent.length)
	{
		if (playerName.length)
		{
			return [playerName stringByReplacingCharactersInRange:[playerName rangeOfString:prefixLastComponent] withString:@""];
		}
	}
	
    return @"";
}

@end
