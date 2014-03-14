//
//  DKCViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuScreen/DKCMainMenuViewController.h"
#import "Infrastructure/UIView+UIView_RoundCorner.h"

@interface DKCViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *Title;
@property (nonatomic, strong) IBOutlet UIImageView *BallImageView;

@end
