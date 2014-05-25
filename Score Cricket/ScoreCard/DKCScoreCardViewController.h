//
//  DKCScoreCardViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKCScoreCardBattingTableViewCell.h"
#import "DKCScoreCordBowlingTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "DKCScoreCardHeaderView.h"
#import "GAITrackedViewController.h"
#import <Parse/Parse.h>
#import "iAd/ADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface DKCScoreCardViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate,GADBannerViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *MatchData;
@property (nonatomic, strong) NSString *currentInnings;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *DNBBatsmans;
@property (nonatomic, strong) NSMutableArray *DidBatBatsmans;
@property (nonatomic, strong) NSMutableArray *bowledBowlers;
@property (nonatomic, strong) DKCScoreCardHeaderView *headerView;
@property (nonatomic, strong) UIView *disabledView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic)BOOL isLive;
@end
