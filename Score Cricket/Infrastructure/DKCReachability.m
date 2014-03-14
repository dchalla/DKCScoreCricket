//
//  DKCReachability.m
//  Score Cricket
//
//  Created by Dinesh Challa on 7/5/13.
//
//

#import "DKCReachability.h"
#import "Reachability.h"

@implementation DKCReachability

+ (BOOL) connectedToNetwork
{
	Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [reach currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

+ (BOOL) checkInternet
{
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES)
	{
		return NO;
	}
	else {
		return YES;
	}
}

@end
