//
//  DKCMainMenuViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIView+UIView_RoundCorner.h"
#import "../CreateMatch/DKCCreateMatchViewController.h"
#import "GAITrackedViewController.h"

@interface DKCMainMenuViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UIButton *CreateMatch;
@property (nonatomic,strong) IBOutlet UIButton *InProgressMatch;
@property (nonatomic,strong) IBOutlet UIButton *CompletedMatches;
@property (nonatomic,strong) IBOutlet UIImageView *Bat;

@property (nonatomic,strong) IBOutlet UILabel *CreateMatchLabel;
@property (nonatomic,strong) IBOutlet UILabel *EditMatchLabel;
@property (nonatomic,strong) IBOutlet UILabel *CompletedMatchesLabel;

@property (nonatomic, strong) UIView *disabledView;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundInitialImageView;
@property (nonatomic, strong) UIImage *backgroundInitialImage;

-(IBAction)CreateMatchWithAnimation:(id)sender;
-(IBAction)InProgressMatchesWithAnimation:(id)sender;
-(IBAction)CompletedMatchesWithAnimation:(id)sender;

@end
