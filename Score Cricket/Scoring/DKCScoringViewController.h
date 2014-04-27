//
//  DKCScoringViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIView+UIView_RoundCorner.h"
#import "../Infrastructure/UIButton+GradientColor.h"
#import "../Infrastructure/NSDictionary+MutableDeepCopy.h"
#import "../CommonClasses/DKCEditTeamViewController.h"
#import "DKCSelectBowlerViewController.h"
#import "DKCAdditionalRunsViewController.h"
#import "DKCOutViewController.h"
#import "DKCSelectBatsmanViewController.h"
#import "../ScoreCard/DKCScoreCardViewController.h"
#import "GAITrackedViewController.h"
#import "iAd/ADBannerView.h"


@interface DKCScoringViewController : GAITrackedViewController <EditTeamViewDelegate,SelectBowlerViewDelegate,AdditionalRunsViewDelegate,OutViewDelegate,SelectBatsmanViewDelegate,UIActionSheetDelegate,ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *button0;
@property (nonatomic, strong) IBOutlet UIButton *button1;
@property (nonatomic, strong) IBOutlet UIButton *button2;
@property (nonatomic, strong) IBOutlet UIButton *button3;
@property (nonatomic, strong) IBOutlet UIButton *button4;
@property (nonatomic, strong) IBOutlet UIButton *button6;
@property (nonatomic, strong) IBOutlet UIButton *buttonNumberPlus1;

@property (nonatomic, strong) IBOutlet UIButton *batsman1;
@property (nonatomic, strong) IBOutlet UILabel *batsman1Score;
@property (nonatomic, strong) IBOutlet UILabel *batsman1Balls;
@property (nonatomic, strong) IBOutlet UIButton *batsman2;
@property (nonatomic, strong) IBOutlet UILabel *batsman2Score;
@property (nonatomic, strong) IBOutlet UILabel *batsman2Balls;
@property (nonatomic, strong) IBOutlet UIButton *bowler1;
@property (nonatomic, strong) IBOutlet UILabel *bowler1Overs;
@property (nonatomic, strong) IBOutlet UILabel *bowler1OversDecimal;

@property (nonatomic, strong) IBOutlet UIButton *legbye;
@property (nonatomic, strong) IBOutlet UIButton *bye;
@property (nonatomic, strong) IBOutlet UIButton *wideBall;
@property (nonatomic, strong) IBOutlet UIButton *noball;

@property (nonatomic, strong) IBOutlet UIButton *undo;
@property (nonatomic, strong) IBOutlet UIButton *endinnings;
@property (nonatomic, strong) IBOutlet UIButton *outBatsman;

@property (nonatomic, strong) IBOutlet UILabel *runsDigit1;
@property (nonatomic, strong) IBOutlet UILabel *runsDigit2;
@property (nonatomic, strong) IBOutlet UILabel *runsDigit3;
@property (nonatomic, strong) IBOutlet UILabel *wickets;
@property (nonatomic, strong) IBOutlet UILabel *oversDigit1;
@property (nonatomic, strong) IBOutlet UILabel *oversDigit2;
@property (nonatomic, strong) IBOutlet UILabel *oversDecimalDigit;

@property (nonatomic, strong) IBOutlet UILabel *runRate;
@property (nonatomic, strong) IBOutlet UILabel *thisOverRuns;

@property (nonatomic, strong) NSMutableDictionary *MatchData;
@property (nonatomic, strong) NSMutableDictionary *MatchDataCopy;

@property (nonatomic, strong) IBOutlet UIButton *team1Button;
@property (nonatomic, strong) IBOutlet UIButton *team2Button;

@property (nonatomic, strong) IBOutlet UIButton *onStrikeIconButton;
@property (nonatomic, strong) IBOutlet UIButton *runnersEndIconButton;
@property (nonatomic, strong) IBOutlet UIButton *bowlerIconButton;
@property (nonatomic, strong) IBOutlet UIButton *interchangeBatsmanButton;

@property (nonatomic, strong) IBOutlet UIImageView *helpImageView;
@property (nonatomic, strong) UIBarButtonItem *helpBarButton;
@property (nonatomic, strong) UIButton *helpButton;

@property (nonatomic, strong) IBOutlet UILabel *slashRunsOut;
@property (nonatomic, strong) IBOutlet UILabel *decimalMainOvers;
@property (nonatomic, strong) IBOutlet UILabel *decimalBowlerOvers;

@property (nonatomic, strong) IBOutlet UILabel *scoreCricket;
@property (nonatomic, strong) NSMutableArray *stackUndo;
@property (nonatomic) NSInteger head;
@property (nonatomic) NSInteger maxUndo;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

- (IBAction)EditTeam1:(id)sender;
- (IBAction)EditTeam2:(id)sender;

- (IBAction)Run0:(id)sender;
- (IBAction)Run1:(id)sender;
- (IBAction)Run2:(id)sender;
- (IBAction)Run3:(id)sender;
- (IBAction)Run4:(id)sender;
- (IBAction)Run6:(id)sender;
- (IBAction)RunPlus:(id)sender;

- (IBAction)legByeExtra:(id)sender;
- (IBAction)byeExtra:(id)sender;
- (IBAction)wideExtra:(id)sender;
- (IBAction)noBallExtra:(id)sender;

- (IBAction)undoLastBall:(id)sender;
- (IBAction)EndInnings:(id)sender;
- (IBAction)OutAction:(id)sender;

-(IBAction)ChangeBowler:(id)sender;

-(IBAction)ChangeOnStrikeBatsman:(id)sender;
-(IBAction)ChangeRunnersEndBatsman:(id)sender;

-(IBAction)showScoreBoard:(id)sender;
-(IBAction)InterchangeBatsman:(id)sender;

@end
