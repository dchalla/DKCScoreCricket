//
//  DKCScoreCardViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCScoreCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DKCCreatePList.h"
#import "DKCReachability.h"
#import "UIImage+StackBlur.h"
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif
#import "DKCBackgroundImage.h"
#import "BOZPongRefreshControl.h"


@interface DKCScoreCardViewController ()
@property (nonatomic)CGRect tableViewFrame;
@property (nonatomic)UIImageView *screenshotImageView;
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
@end

@implementation DKCScoreCardViewController
@synthesize MatchData;
@synthesize currentInnings;
@synthesize segment;
@synthesize DNBBatsmans;
@synthesize DidBatBatsmans;
@synthesize bowledBowlers;
@synthesize tableViewFrame;
@synthesize headerView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	if (self.isLive)
	{
		self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.tableView
														 withRefreshTarget:self
														  andRefreshAction:@selector(refreshTriggered)];
	}
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.screenName = @"Score Card";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden=NO;
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[DKCBackgroundImage backgroundImage]]];
    self.tableView.backgroundView.frame = self.tableView.frame;
    self.tableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"FirstInnings",@"SecondInnings", nil]];
    segment.frame = CGRectMake(0, 0, 220, 30);
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        segment.tintColor = [UIColor colorWithWhite:1 alpha:1];
    }else{
        [self.tableView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    }
    
    self.navigationItem.titleView = segment;
    [segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
    if([currentInnings isEqualToString:@"FirstInnings"])
    {
        segment.selectedSegmentIndex = 0;
    }
    else 
    {
        segment.selectedSegmentIndex = 1;
    }
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(handleAction)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    headerView = [[DKCScoreCardHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 67)];
    self.tableView.tableHeaderView = headerView;
    headerView.matchDetails.text = [NSString stringWithFormat:@"%@ vs %@",[[self.MatchData objectForKey:@"Team1"] objectForKey:@"TeamName"],[[self.MatchData objectForKey:@"Team2"] objectForKey:@"TeamName"]];
    
    if ([currentInnings isEqualToString:@"FirstInnings"]) 
    {
        headerView.inningsTitle.text = @"First Innings";
    }
    else 
    {
        headerView.inningsTitle.text = @"Second Innings";
    }
    
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    footerView.textAlignment= NSTextAlignmentCenter;
    footerView.textColor = [UIColor whiteColor];
    footerView.text = @"Designed & Developed by Dinesh Kumar Challa";
    footerView.backgroundColor = [UIColor clearColor];
    
    footerView.font = [UIFont systemFontOfSize:10];
    self.tableView.tableFooterView = footerView;
    
    tableViewFrame = self.tableView.frame;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void) segmentClicked:(id)sender
{
    if (segment.selectedSegmentIndex == 0) 
    {
        currentInnings = @"FirstInnings";
    }
    else 
    {
        currentInnings = @"SecondInnings";
    }
    if ([currentInnings isEqualToString:@"FirstInnings"]) 
    {
        headerView.inningsTitle.text = @"First Innings";
    }
    else 
    {
        headerView.inningsTitle.text = @"Second Innings";
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if (self.isLive)
	{
		[self.pongRefreshControl finishedLoading];
	}
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self rowsInsection:section];
}

- (NSInteger) rowsInsection:(NSInteger) section
{
    // Return the number of rows in the section.
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSMutableDictionary *battingData = [self.MatchData objectForKey:battingTeam];
    
    NSMutableDictionary *bowlingData = [self.MatchData objectForKey:bowlingTeam];
    
    DNBBatsmans = [[NSMutableArray alloc] initWithCapacity:0];
    DidBatBatsmans = [[NSMutableArray alloc] initWithCapacity:0];
    bowledBowlers = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=1; i<12; i++) 
    {
        NSString *outType = [[[battingData objectForKey: [NSString stringWithFormat:@"P%d",i]]objectForKey:@"Batting"] objectForKey:@"OutType"];
        int balls =[[[[battingData objectForKey: [NSString stringWithFormat:@"P%d",i]] objectForKey:@"Batting"] objectForKey:@"Balls"] intValue];
        if ([outType isEqualToString:@"DNB"] && balls==0) 
        {
            [DNBBatsmans addObject:[battingData objectForKey: [NSString stringWithFormat:@"P%d",i]]];
        }
        else
        {
            [DidBatBatsmans addObject:[battingData objectForKey: [NSString stringWithFormat:@"P%d",i]]];
        }
    }
    NSArray *sortedDidBatsmanArray;
    sortedDidBatsmanArray = [DidBatBatsmans sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"BattingOrder"];
        NSNumber *second = [b objectForKey:@"BattingOrder"];
        return [first compare:second];
    }];
    
    DidBatBatsmans = [sortedDidBatsmanArray mutableCopy];
    
    for (int i=11; i>0; i--) 
    {
        NSMutableDictionary *player = [bowlingData objectForKey: [NSString stringWithFormat:@"P%d",i]];
        NSMutableDictionary *playerBowlingData = [player objectForKey:@"Bowling"];
        int balls = [[playerBowlingData objectForKey:@"Balls"] intValue];
        if(balls > 0 )
        {
            [bowledBowlers addObject:player];
        }
        
    }
    NSArray *sortedDidBowlBowlersArray;
    sortedDidBowlBowlersArray = [bowledBowlers sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"BowlingOrder"];
        NSNumber *second = [b objectForKey:@"BowlingOrder"];
        return [first compare:second];
    }];
    bowledBowlers = [sortedDidBowlBowlersArray mutableCopy];
    
    if(section==0)
    {
        return [DidBatBatsmans count];
    }
    else if (section==1) 
    {
        return 1;
    }
    else if (section==2) 
    {
        return 1;
    }
    else
    {
        return [bowledBowlers count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0)
    {
        return 56;
    }
    else if([indexPath section] == 3)
    {
        return 56;
    }
    else 
    {
        return 46;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSMutableDictionary *bowlingData = [self.MatchData objectForKey:bowlingTeam];
    
    NSMutableDictionary *stats = [[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"];
    
    // Configure the cell...
    if([indexPath section] == 0)
    {
        static NSString *CellIdentifier = @"BattingCell";
        NSMutableDictionary *player = [DidBatBatsmans objectAtIndex:[indexPath row]];
        DKCScoreCardBattingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[DKCScoreCardBattingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.nameLabel.text =[player objectForKey:@"Name"];
        int score = [[[player objectForKey:@"Batting"] objectForKey:@"Score"] intValue];
        int balls =[[[player objectForKey:@"Batting"] objectForKey:@"Balls"] intValue];
        cell.runsLabel.text =[NSString stringWithFormat:@"%d",score];
        cell.ballsLabel.text = [NSString stringWithFormat:@"(%d)",balls];
        cell.foursLabel.text = [NSString stringWithFormat:@"4's: %@", [[[player objectForKey:@"Batting"] objectForKey:@"4"] stringValue]];
        cell.sixersLabel.text = [NSString stringWithFormat:@"6's: %@", [[[player objectForKey:@"Batting"] objectForKey:@"6"] stringValue]];
        
        if (balls == 0) 
        {
            cell.strikeRateLabel.text = [NSString stringWithFormat:@"S.R.: %0.1d", 0];
        }
        else 
        {
            cell.strikeRateLabel.text = [NSString stringWithFormat:@"S.R.: %0.1f", ((CGFloat)score/balls)*100];
        }
        
        NSString *outType =[[player objectForKey:@"Batting"] objectForKey:@"OutType"];
        
        NSString *outByID;
        if ([outType isEqualToString:@"Run Out"]) 
        {
            outByID =[[player objectForKey:@"Batting"] objectForKey:@"OutByFielder"];
        }
        else 
        {
            outByID = [[player objectForKey:@"Batting"] objectForKey:@"OutByBowler"];
        }
        
        
        NSString *outBy = [[bowlingData objectForKey:outByID] objectForKey:@"Name"];
        if ([outType isEqualToString:@"DNB"]) 
        {
            if(balls > 0)
            {
                cell.wicketLabel.text =@"not out";
            }
            else 
            {
                cell.wicketLabel.text =[NSString stringWithFormat:@"%@",outType];
            }
            
        }
        else 
        {
            if ([outType isEqualToString:@"Timed Out"] || [outType isEqualToString:@"Retired"]) 
            {
                cell.wicketLabel.text = outType;
            }
            else if ([outType isEqualToString:@"Caught"]) 
            {
                NSString *outByFielderID =[[player objectForKey:@"Batting"] objectForKey:@"OutByFielder"];
                NSString *outByFielder = [[bowlingData objectForKey:outByFielderID] objectForKey:@"Name"];
                cell.wicketLabel.text =[NSString stringWithFormat:@"B by %@, C by %@",outBy,outByFielder];
            }
            else if ([outType isEqualToString:@"Stumped"]) 
            {
                NSString *outByFielderID =[[player objectForKey:@"Batting"] objectForKey:@"OutByFielder"];
                NSString *outByFielder = [[bowlingData objectForKey:outByFielderID] objectForKey:@"Name"];
                cell.wicketLabel.text =[NSString stringWithFormat:@"B by %@, st by %@",outBy,outByFielder];
            }
            else 
            {
                cell.wicketLabel.text =[NSString stringWithFormat:@"%@ by %@",outType,outBy];
            }
            
        }
        return cell;
    }
    else if ([indexPath section]==1)
    {
        static NSString *CellIdentifier = @"ExtraCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
            {
                cell.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            }
            else
            {
                UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, cell.backgroundView.frame.size.width - 2*9, 56)];
                backgroundColorView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
                backgroundColorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [cell.backgroundView addSubview:backgroundColorView];
                cell.backgroundView.backgroundColor = [UIColor clearColor];
            }

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        }
        if([indexPath row] == 0)
        {
            int Balls= [[stats objectForKey:@"Balls"] intValue];
            cell.textLabel.text=[NSString stringWithFormat:@"Total: %d ( %d wickets %0.1f overs )  Extras: %d",[[stats objectForKey:@"Score"] intValue],[[stats objectForKey:@"Wickets"] intValue], ((Balls/6)+((Balls%6)/10.0f)),[[stats objectForKey:@"Extras"] intValue]];
        }
        return cell;
    }
    else if ([indexPath section]==2)
    {
        static NSString *CellIdentifier = @"ExtraCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
            {
                cell.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            }
            else
            {
                UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, cell.backgroundView.frame.size.width - 2*9, 56)];
                backgroundColorView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
                backgroundColorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [cell.backgroundView addSubview:backgroundColorView];
                cell.backgroundView.backgroundColor = [UIColor clearColor];
            }
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        }
        if([indexPath row] == 0)
        {
            NSString *tempString = @"DNB: ";
            for (NSMutableDictionary *player in DNBBatsmans) {
                tempString = [tempString stringByAppendingFormat:@"%@, ",[player objectForKey:@"Name"]];
            }
            cell.textLabel.text=tempString;
        }
        return cell;
    }
    else 
    {
        NSMutableDictionary *player = [bowledBowlers objectAtIndex:[indexPath row]];
        NSMutableDictionary *playerBowlingData = [player objectForKey:@"Bowling"];
        int Balls = [[playerBowlingData objectForKey:@"Balls"] intValue];
        static NSString *CellIdentifier = @"Cell";
        DKCScoreCordBowlingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[DKCScoreCordBowlingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        CGFloat overs = ((Balls/6)+((Balls%6)/10.0f));
        cell.nameLabel.text=[player objectForKey:@"Name"];
        cell.runsLabel.text = [NSString stringWithFormat:@"%d/%d",[[playerBowlingData objectForKey:@"Runs"] intValue],[[playerBowlingData objectForKey:@"Wickets"] intValue]];
        cell.foursLabel.text = [NSString stringWithFormat:@"4's: %d",[[playerBowlingData objectForKey:@"4"] intValue]];
        cell.sixersLabel.text = [NSString stringWithFormat:@"6's: %d",[[playerBowlingData objectForKey:@"6"] intValue]];
        cell.dotLabel.text = [NSString stringWithFormat:@"Dot's: %d",[[playerBowlingData objectForKey:@"0"] intValue]];
        cell.oversLabel.text = [NSString stringWithFormat:@"%0.1f",overs];
        cell.EconomyRateLabel.text = [NSString stringWithFormat:@"E.R.: %0.1f",(CGFloat)[[playerBowlingData objectForKey:@"Runs"] intValue]/overs];
        cell.ExtrasLabel.text = [NSString stringWithFormat:@"Extras: %d",[[playerBowlingData objectForKey:@"Extras"] intValue]];
        return cell;
        
    }
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    else if (section==1) {
        return 0;
    }
    else if (section==2) {
        return 0;
    }
    else {
        return 40;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self rowsInsection:section]<=0)
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    UIView *tempBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(9, 5, tempBackView.frame.size.width - 9*2, 35)];
    backgroundColorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [tempBackView addSubview:backgroundColorView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(11, backgroundColorView.frame.size.height-1, backgroundColorView.frame.size.width - 2*11, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [backgroundColorView addSubview:lineView];
    
    UILabel *tempView = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 310, 40)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.textAlignment = NSTextAlignmentLeft;
    tempView.textColor = [UIColor colorWithWhite:1 alpha:1];
    if (section==0) {
        tempView.text = @"Batting";
    }
    else if (section==1) {
        [backgroundColorView removeFromSuperview];
        tempView.text = @"";
    }
    else if (section==2) {
        [backgroundColorView removeFromSuperview];
        tempView.text = @"";
    }
    else {
        tempView.text = @"Bowling";
    }
    [tempBackView addSubview:tempView];
    return tempBackView;
    
}


#pragma mark - action menu
- (void)handleAction
{
	if (self.isLive)
	{
		[self shareScoreCard];
		return;
	}
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share score card", @"Transfer match", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
			[self shareScoreCard];
            break;
        case 1:
			[self shareMatch];
            break;
        default:
            break;
    }
}

- (void)shareScoreCard
{
	CGRect tableViewRect = self.tableView.frame;
	NSString *inning = self.currentInnings;
	[self showScreenshotWhileGettingImagesForMail];
	UIImage *firstInningsimg = [self imageFromCurrentViewForInnings:@"FirstInnings"];
	UIImage *secondInningsimg = [self imageFromCurrentViewForInnings:@"SecondInnings"];
	NSArray *objectsToShare = @[firstInningsimg,secondInningsimg,@"http://www.facebook.com/ScoreCricket"];
	
	self.tableView.frame = tableViewRect;
	self.currentInnings = inning;
    if ([currentInnings isEqualToString:@"FirstInnings"])
    {
        headerView.inningsTitle.text = @"First Innings";
    }
    else
    {
        headerView.inningsTitle.text = @"Second Innings";
    }
    
	[self.tableView reloadData];
	[_screenshotImageView removeFromSuperview];
	
	UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [controller setValue:[NSString stringWithFormat:@"Score Cricket Score Card for %@ vs %@",[[self.MatchData objectForKey:@"Team1"] objectForKey:@"TeamName"],[[self.MatchData objectForKey:@"Team2"] objectForKey:@"TeamName"]] forKey:@"subject"];
    [self presentViewController:controller animated:YES completion:nil];

}

- (void)shareMatch
{
	NSString *filePath = [DKCCreatePList pathForFileName:[MatchData objectForKey:@"FileName"]];
	if (!filePath) {
		return;
	}
	
	NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *objectsToShare = @[url];
	
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil]; 
}


#pragma taking tableviewscreenshot
-(UIImage *)imageFromCurrentViewForInnings:(NSString *)innings
{
    self.currentInnings = innings;
    if ([currentInnings isEqualToString:@"FirstInnings"]) 
    {
        headerView.inningsTitle.text = @"First Innings";
    }
    else 
    {
        headerView.inningsTitle.text = @"Second Innings";
    }
    
    int height = 70 + 46 + 46 + [self rowsInsection:0]*56 + 40 + [self rowsInsection:3]*56 + 40 + 160;
    
    
    self.tableView.frame = CGRectMake(0, 0, 480, height);
    [self.tableView reloadData];
    UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, YES, 3);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)showScreenshotWhileGettingImagesForMail
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 3);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_screenshotImageView removeFromSuperview];
    _screenshotImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _screenshotImageView.image = img;
    [self.view addSubview:_screenshotImageView];
}

#pragma mark - Notifying the pong refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.isLive)
	{
		[self.pongRefreshControl scrollViewDidScroll];
	}
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.isLive)
	{
		[self.pongRefreshControl scrollViewDidEndDragging];
	}
    
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered
{
	__weak DKCScoreCardViewController *wSelf = self;
	
	PFQuery *query = [PFQuery queryWithClassName:@"DevMatches2"];
	[query whereKey:@"FileName" equalTo:self.MatchData[@"FileName"]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error)
		{
			NSLog(@"Successfully Parse retrieved %d match data.", objects.count);
			
			if (objects.count)
			{
				PFObject *pf_MatchObject = [objects objectAtIndex:0];
				wSelf.MatchData = pf_MatchObject[@"MatchData"];
				[wSelf.pongRefreshControl performSelector:@selector(finishedLoading) withObject:self afterDelay:0.8];
				[wSelf.tableView reloadData];
			}
			
		}
		else
		{
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];


}






@end
