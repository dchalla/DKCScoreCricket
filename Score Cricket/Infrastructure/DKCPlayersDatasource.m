//
//  DKCPlayersDatasource.m
//  Score Cricket
//
//  Created by Dinesh Challa on 4/27/14.
//
//

#import "DKCPlayersDatasource.h"


static DKCPlayersDatasource *sharedPlayersDatasource;

@interface DKCPlayersDatasource()

@property (nonatomic, strong) PJTernarySearchTree *playersTree;

@end

@implementation DKCPlayersDatasource


+ (DKCPlayersDatasource *)sharedPlayersDatasource
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedPlayersDatasource = [[DKCPlayersDatasource alloc] init];
	});
	return sharedPlayersDatasource;
}

- (NSString *)playersDatasourcePath
{
	NSString * savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"playersDatasource.tree"];
	
	return savePath;
}

- (PJTernarySearchTree *)playersTree
{
	if (!_playersTree)
	{
		_playersTree = [PJTernarySearchTree treeWithFile:[self playersDatasourcePath]];
		if (!_playersTree)
		{
			_playersTree = [[PJTernarySearchTree alloc] init];
		}
	}
	return _playersTree;
}

- (void)insertPlayerName:(NSString *)playerName
{
	if (playerName.length > 0)
	{
		[self.playersTree insertString:playerName];
	}
}

- (NSString *)retrievePlayerNameWithPrefix:(NSString *)prefix
{
	NSArray *playerNames = [self.playersTree retrievePrefix:prefix countLimit:1];
	if (playerNames.count)
	{
		return [playerNames firstObject];
	}
	return @"";
}

- (void)savePlayersDatasource
{
	[self.playersTree saveTreeToFile:[self playersDatasourcePath]];
}


@end
