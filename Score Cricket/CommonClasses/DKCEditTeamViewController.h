//
//  DKCEditTeamViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKCEditTeamCell.h"
#import "HTAutocompleteTextField.h"

@protocol EditTeamViewDelegate <NSObject>
@required
- (void) dismissEditTeam;
@end

@interface DKCEditTeamViewController : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *tableData;
@property (nonatomic, strong) HTAutocompleteTextField *txtField;
@property (nonatomic, strong) id<EditTeamViewDelegate> delegate;
@property (nonatomic, strong) UIImage *backgroundBlurredImage;
@property (nonatomic) BOOL fromScoringViewController;
@end
