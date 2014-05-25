//
//  DKCOnlineMatchesTableViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/16/14.
//
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

@interface DKCOnlineMatchesViewController : UIViewController <ADBannerViewDelegate,GADBannerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL isLive;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
