//
//  DKCPlayersDatasource.h
//  Score Cricket
//
//  Created by Dinesh Challa on 4/27/14.
//
//

#import <Foundation/Foundation.h>
#import "PJTernarySearchTree.h"

@interface DKCPlayersDatasource : NSObject

+ (DKCPlayersDatasource *)sharedPlayersDatasource;
- (void)insertPlayerName:(NSString *)playerName;
- (NSString *)retrievePlayerNameWithPrefix:(NSString *)prefix;
- (void)savePlayersDatasource;

@end
