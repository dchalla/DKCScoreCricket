//
//  DKCCreateMatchViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIView+UIView_RoundCorner.h"
#import "../CommonClasses/DKCEditTeamViewController.h"
#import "../Scoring/DKCScoringViewController.h"
#import "GAITrackedViewController.h"


@interface DKCCreateMatchViewController : GAITrackedViewController <UIPickerViewDelegate,UIPickerViewDataSource,EditTeamViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *oversPerInnings;
@property (nonatomic, strong) IBOutlet UIButton *oversPerInningsValue;
@property (nonatomic, strong) IBOutlet UILabel *tossWon;
@property (nonatomic, strong) IBOutlet UIButton *tossWonValue;
@property (nonatomic, strong) IBOutlet UILabel *battingFirst;
@property (nonatomic, strong) IBOutlet UIButton *battingFirstValue;

@property (nonatomic, strong) IBOutlet UIButton *team1Button;
@property (nonatomic, strong) IBOutlet UIButton *team2Button;
@property (nonatomic, strong) IBOutlet UIButton *StartScoring;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *oversPerInningsData;
@property (nonatomic, strong) NSMutableArray *tossWonData;
@property (nonatomic, strong) NSMutableArray *battingFirstData;

@property (nonatomic, strong) NSMutableDictionary *team1Data;
@property (nonatomic, strong) NSMutableDictionary *team2Data;

@property (nonatomic, strong) NSString *team1Title;
@property (nonatomic, strong) NSString *team2Title;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

-(IBAction)OversPerInningsAction:(id)sender;
-(IBAction)TossWonAction:(id)sender;
-(IBAction)BattingFirstAction:(id)sender;
-(IBAction)StartScoringAction:(id)sender;

-(IBAction)EditTeam1:(id)sender;
-(IBAction)EditTeam2:(id)sender;

- (void) refreshView;

@end
