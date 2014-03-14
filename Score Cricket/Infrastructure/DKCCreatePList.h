//
//  DKCCreatePList.h
//  Score Cricket
//
//  Created by Dinesh Challa on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKCCreatePList : NSObject

+(void)CreatePlistDictionaryWithName:(NSString *)name withData:(id)plistData;
+ (NSMutableDictionary *)ReadPlistDictionaryWithName:(NSString *)name;
+ (NSMutableArray *)ReadPlistArrayWithName:(NSString *)name;
+ (void)CreatePlistArrayWithName:(NSString *)name withData:(NSMutableArray *)plistData;

+ (void) AddObjectToMatchesListWithFileName:(NSString *)fileName andTeam1:(NSString *)Team1 andTeam2:(NSString *)Team2 ;
+ (void) DeleteMatchWithFileName:(NSString *)fileName;
+ (NSMutableArray *)GetListOfMatches;
+ (void) RefreshMatchesListWithNewData:(NSMutableArray *)matchesList;
+ (NSString *)pathForFileName:(NSString *)name;

@end
