//
//  DKCCreatePList.m
//  Score Cricket
//
//  Created by Dinesh Challa on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCCreatePList.h"

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

