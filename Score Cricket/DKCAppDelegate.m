//
//  DKCAppDelegate.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCAppDelegate.h"
#import "Appirater.h"
#import "DKCCreatePList.h"
#import "GAI.h"
#import "GAITracker.h"
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif
#import "DKCPlayersDatasource.h"

@implementation DKCAppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Appirater setAppId:@"538655929"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
	
	
	// Optional: automatically send uncaught exceptions to Google Analytics.
	[GAI sharedInstance].trackUncaughtExceptions = YES;
	
	// Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
	[GAI sharedInstance].dispatchInterval = 20;
	
	// Optional: set Logger to VERBOSE for debug information.
	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
	
	// Initialize tracker.
	id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47902581-1"];
	
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[DKCPlayersDatasource sharedPlayersDatasource] savePlayersDatasource];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[[DKCPlayersDatasource sharedPlayersDatasource] savePlayersDatasource];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)
url sourceApplication:(NSString *) sourceApplication annotation:(id)
annotation {
	if (url) {
		NSData *data = [NSData dataWithContentsOfURL:url];
		
		NSPropertyListFormat plistFormat;
        NSError *error;
        NSMutableDictionary *tempDict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&plistFormat error:&error];
        
        NSString *fileName = [tempDict valueForKey:@"FileName"];
        [DKCCreatePList DeleteMatchWithFileName:fileName];
        
        [DKCCreatePList CreatePlistDictionaryWithName:fileName withData:tempDict];
        
        //Add match to ListOfMatches
        [DKCCreatePList AddObjectToMatchesListWithFileName:fileName andTeam1:[[tempDict objectForKey:@"Team1"] objectForKey:@"TeamName"] andTeam2:[[tempDict objectForKey:@"Team2"] objectForKey:@"TeamName"]];
        
        
        NSString *Team1 = [[tempDict objectForKey:@"Team1"] objectForKey:@"TeamName"];
        NSString *Team2 = [[tempDict objectForKey:@"Team2"] objectForKey:@"TeamName"];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Match %@ vs %@ received successfully",Team1,Team2 ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
		
	}
	return YES;
}

@end
