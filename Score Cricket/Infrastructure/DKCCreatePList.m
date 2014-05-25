//
//  DKCCreatePList.m
//  Score Cricket
//
//  Created by Dinesh Challa on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCCreatePList.h"
#import <Parse/Parse.h>

@implementation DKCCreatePList


+ (void)DeletePlistWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    }
    
    NSError *error;
    if ([fileManager removeItemAtPath:path error:&error] != YES)
    {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

+ (void)CreatePlistDictionaryWithName:(NSString *)name withData:(NSMutableDictionary *)plistData
{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    }
    
    
    [plistData writeToFile:path atomically:YES];  
    
      
}

+ (void)CreatePlistArrayWithName:(NSString *)name withData:(NSMutableArray *)plistData
{ 
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    }
    
    
    [plistData writeToFile:path atomically:YES];   
}

+ (NSMutableDictionary *)ReadPlistDictionaryWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
     if ([fileManager fileExistsAtPath: path]) 
     {
         NSMutableDictionary *propertyDict = [NSMutableDictionary  dictionaryWithContentsOfFile:path];
         return propertyDict;
     }
     else 
     {
         return [[NSMutableDictionary alloc] init];
     }
}

+ (NSString *)pathForFileName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
	if ([fileManager fileExistsAtPath: path])
	{
		return path;
	}
	return nil;
}


+ (NSMutableArray *)ReadPlistArrayWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        NSMutableArray *propertyArray = [NSMutableArray  arrayWithContentsOfFile:path];
        return propertyArray;
    }
    else 
    {
        return [[NSMutableArray alloc] init];
    }
}

+ (void) AddObjectToMatchesListWithFileName:(NSString *)fileName andTeam1:(NSString *)Team1 andTeam2:(NSString *)Team2 
{
    NSMutableDictionary *matchDetails = [[NSMutableDictionary alloc] initWithCapacity:0];
    [matchDetails setObject:fileName forKey:@"FileName"];
    [matchDetails setObject:Team1 forKey:@"Team1"];
    [matchDetails setObject:Team2 forKey:@"Team2"];
    [matchDetails setObject:@"current" forKey:@"isCurrent"];
    
    NSMutableArray *matchesList = [self ReadPlistArrayWithName:@"ListOfMatches"];
    
    [matchesList addObject:matchDetails];

    [self CreatePlistArrayWithName:@"ListOfMatches" withData:matchesList];

}

+ (void) CreateParseObjectWithFileName:(NSString *)fileName matchData:(NSMutableDictionary *)matchData status:(NSString *)status
{
    PFObject *pf_MatchObject = [PFObject objectWithClassName:DKC_PROD_MATCHES];
	[pf_MatchObject setObject:fileName forKey:@"FileName"];
    [pf_MatchObject setObject:matchData[@"Team1"][@"TeamName"] forKey:@"Team1"];
    [pf_MatchObject setObject:matchData[@"Team2"][@"TeamName"] forKey:@"Team2"];
    [pf_MatchObject setObject:status forKey:@"isCurrent"];
	[pf_MatchObject setObject:status forKey:@"Status"];
	[pf_MatchObject setObject:matchData forKey:@"MatchData"];
	[pf_MatchObject setObject:[NSDate date] forKey:@"MatchStartDate"];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
	[pf_MatchObject setObject:[calendar dateFromComponents:todayComponents] forKey:@"DatePickerStartDate"];
	[pf_MatchObject saveInBackground];
	
}

+ (void) UpdateParseObjectWithFileName:(NSString *)fileName matchData:(NSMutableDictionary *)matchData status:(NSString *)status
{
	NSMutableDictionary *matchDataCopy = [matchData mutableCopy];
	PFQuery *query = [PFQuery queryWithClassName:DKC_PROD_MATCHES];
	[query whereKey:@"FileName" equalTo:fileName];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error)
		{
			NSLog(@"Successfully Parse retrieved %d match data.", objects.count);
			
			if (objects.count)
			{
				PFObject *pf_MatchObject = [objects objectAtIndex:0];
				[pf_MatchObject setObject:matchDataCopy[@"Team1"][@"TeamName"] forKey:@"Team1"];
				[pf_MatchObject setObject:matchDataCopy[@"Team2"][@"TeamName"] forKey:@"Team2"];
				if (![status isEqualToString:@"current"])
				{
					[pf_MatchObject setObject:status forKey:@"isCurrent"];
					[pf_MatchObject setObject:status forKey:@"Status"];
				}
				
				[pf_MatchObject setObject:matchDataCopy forKey:@"MatchData"];
				
				NSString *firstInningsBattingTeam = matchDataCopy[@"FirstInnings"][@"BattingTeam"];
				if ([firstInningsBattingTeam isEqualToString:@"Team1"])
				{
					NSMutableDictionary *stats = [[matchDataCopy objectForKey:@"FirstInnings"] objectForKey:@"Statistics"];
					[pf_MatchObject setObject:stats[@"Score"] forKey:@"Team1Score"];
					[pf_MatchObject setObject:stats[@"Balls"] forKey:@"Team1Balls"];
					
					stats = [[matchDataCopy objectForKey:@"SecondInnings"] objectForKey:@"Statistics"];
					[pf_MatchObject setObject:stats[@"Score"] forKey:@"Team2Score"];
					[pf_MatchObject setObject:stats[@"Balls"] forKey:@"Team2Balls"];
					
				}
				else
				{
					NSMutableDictionary *stats = [[matchDataCopy objectForKey:@"FirstInnings"] objectForKey:@"Statistics"];
					[pf_MatchObject setObject:stats[@"Score"] forKey:@"Team2Score"];
					[pf_MatchObject setObject:stats[@"Balls"] forKey:@"Team2Balls"];
					
					stats = [[matchDataCopy objectForKey:@"SecondInnings"] objectForKey:@"Statistics"];
					[pf_MatchObject setObject:stats[@"Score"] forKey:@"Team1Score"];
					[pf_MatchObject setObject:stats[@"Balls"] forKey:@"Team1Balls"];
				}
				[pf_MatchObject saveInBackground];
			}
			
		}
		else
		{
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}


+ (void) DeleteMatchWithFileName:(NSString *)fileName
{
    NSMutableArray *matchesList = [DKCCreatePList GetListOfMatches];
    
    for (NSMutableDictionary *tempDict in matchesList)
    {
        if ([[tempDict valueForKey:@"FileName"] isEqualToString:fileName])
        {
            [self DeletePlistWithName:fileName];
            [matchesList removeObject:tempDict];
            break;
        }
    }
    
    [self CreatePlistArrayWithName:@"ListOfMatches" withData:matchesList];
}

+ (NSMutableArray *)GetListOfMatches
{
    return [self ReadPlistArrayWithName:@"ListOfMatches"];
}

+ (void) RefreshMatchesListWithNewData:(NSMutableArray *)matchesList
{
    [self CreatePlistArrayWithName:@"ListOfMatches" withData:matchesList];
}
    


@end

