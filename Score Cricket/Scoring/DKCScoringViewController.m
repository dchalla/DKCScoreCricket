//
//  DKCScoringViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCScoringViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DKCCReatePlist.h"
#import "UIImage+StackBlur.h"

@interface DKCScoringViewController ()
@property (nonatomic) BOOL didEndInnings;
@property (nonatomic) BOOL isHelpImageVisible;
@end


@implementation DKCScoringViewController
@synthesize button0;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button6;
@synthesize buttonNumberPlus1;

@synthesize batsman1;
@synthesize batsman1Score;
@synthesize batsman1Balls;
@synthesize batsman2;
@synthesize batsman2Score;
@synthesize batsman2Balls;
@synthesize bowler1;
@synthesize bowler1Overs;
@synthesize bowler1OversDecimal;

@synthesize legbye;
@synthesize bye;
@synthesize wideBall;
@synthesize noball;

@synthesize endinnings;
@synthesize undo;
@synthesize outBatsman;

@synthesize runsDigit1;
@synthesize runsDigit2;
@synthesize runsDigit3;
@synthesize wickets;

@synthesize oversDigit1;
@synthesize oversDigit2;
@synthesize oversDecimalDigit;

@synthesize inningTitle;
@synthesize runRate;
@synthesize thisOverRuns;

@synthesize team1Button;
@synthesize team2Button;

@synthesize MatchData;
@synthesize MatchDataCopy;

@synthesize onStrikeIconButton;
@synthesize runnersEndIconButton;
@synthesize bowlerIconButton;

@synthesize stackUndo;
@synthesize head;
@synthesize maxUndo;

@synthesize interchangeBatsmanButton;

@synthesize didEndInnings;

@synthesize helpImageView;
@synthesize helpBarButton;
@synthesize isHelpImageVisible;
@synthesize helpButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Score Cricket";
    self.screenName = @"Scoring";
    didEndInnings = NO;
    
    self.navigationItem.backBarButtonItem = nil;
   /* [button0 addGradientWithCornerRadius:8];
    [button1 addGradientWithCornerRadius:8];
    [button2 addGradientWithCornerRadius:8];
    [button3 addGradientWithCornerRadius:8];
    [button4 addGradientWithCornerRadius:8];
    [button6 addGradientWithCornerRadius:8];
    [buttonNumberPlus1 addGradientWithCornerRadius:8];
    
    [bye addGradientWithCornerRadius:8];
    [legbye addGradientWithCornerRadius:8];
    [noball addGradientWithCornerRadius:8];
    [wideBall addGradientWithCornerRadius:8];
    
    
    [endinnings addGradientWithCornerRadius:8];
    [undo addGradientWithCornerRadius:8];
    [outBatsman addGradientWithCornerRadius:8];
    */
    onStrikeIconButton.layer.cornerRadius = onStrikeIconButton.frame.size.width/2;
    runnersEndIconButton.layer.cornerRadius = runnersEndIconButton.frame.size.width/2;
    [bowlerIconButton addGradientWithCornerRadius:10];
    
    
    button0.layer.cornerRadius = button0.frame.size.width/2;
    button1.layer.cornerRadius = button1.frame.size.width/2;
    button2.layer.cornerRadius = button2.frame.size.width/2;
    button3.layer.cornerRadius = button3.frame.size.width/2;
    button4.layer.cornerRadius = button4.frame.size.width/2;
    button6.layer.cornerRadius = button6.frame.size.width/2;
    buttonNumberPlus1.layer.cornerRadius = buttonNumberPlus1.frame.size.width/2;
    
    bye.layer.cornerRadius = 4;
    legbye.layer.cornerRadius = 4;
    noball.layer.cornerRadius = 4;
    wideBall.layer.cornerRadius = 4;
    
    endinnings.layer.cornerRadius = 4;
    undo.layer.cornerRadius = 4;
    outBatsman.layer.cornerRadius = 4;
    
    [[interchangeBatsmanButton layer] setBorderWidth:2.0f];
    [[interchangeBatsmanButton layer] setBorderColor:[UIColor colorWithWhite:0.7 alpha:0.6].CGColor];
    [interchangeBatsmanButton makeRoundedCorner:4];
    
    
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"]];
    
    [self.team1Button setTitle:[[self.MatchData objectForKey:@"Team1"] objectForKey:@"TeamName"] forState:UIControlStateNormal];
    [self.team2Button setTitle:[[self.MatchData objectForKey:@"Team2"] objectForKey:@"TeamName"] forState:UIControlStateNormal];
    
    helpImageView.alpha = 0.0;
    helpBarButton = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStylePlain target:self action:@selector(helpBarButtonTapped:)];
    
    
    self.navigationItem.rightBarButtonItem = helpBarButton;
    
    
    self.stackUndo = [[NSMutableArray alloc] initWithCapacity:0];
    head = 0;
    maxUndo = 25;
    
    self.backgroundImageView.image = [self.backgroundImageView.image stackBlur:60];
    [self addMotionAffect];
    
}

- (void)addMotionAffect
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-10.0];
    xAxis.maximumRelativeValue = [NSNumber numberWithFloat:10.0];
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-10.0];
    yAxis.maximumRelativeValue = [NSNumber numberWithFloat:10.0];
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis,yAxis];
    [self.button0 addMotionEffect:group];
    [self.button1 addMotionEffect:group];
    [self.button2 addMotionEffect:group];
    [self.button3 addMotionEffect:group];
    [self.button4 addMotionEffect:group];
    [self.button6 addMotionEffect:group];
    [self.buttonNumberPlus1 addMotionEffect:group];
    
    [self.batsman1 addMotionEffect:group];
    [self.batsman1Score addMotionEffect:group];
    [self.batsman1Balls addMotionEffect:group];
    [self.batsman2 addMotionEffect:group];
    [self.batsman2Score addMotionEffect:group];
    [self.batsman2Balls addMotionEffect:group];
    [self.bowler1 addMotionEffect:group];
    [self.bowler1Overs addMotionEffect:group];
    [self.bowler1OversDecimal addMotionEffect:group];
    [self.legbye addMotionEffect:group];
    [self.bye addMotionEffect:group];
    [self.wideBall addMotionEffect:group];
    [self.noball addMotionEffect:group];
    [self.undo addMotionEffect:group];
    [self.endinnings addMotionEffect:group];
    [self.outBatsman addMotionEffect:group];
    [self.runsDigit1 addMotionEffect:group];
    [self.runsDigit2 addMotionEffect:group];
    [self.runsDigit3 addMotionEffect:group];
    [self.wickets addMotionEffect:group];
    [self.oversDigit1 addMotionEffect:group];
    [self.oversDigit2 addMotionEffect:group];
    [self.oversDecimalDigit addMotionEffect:group];
    [self.inningTitle addMotionEffect:group];
    [self.runRate addMotionEffect:group];
    [self.thisOverRuns addMotionEffect:group];
    [self.team1Button addMotionEffect:group];
    [self.team2Button addMotionEffect:group];
    [self.onStrikeIconButton addMotionEffect:group];
    [self.runnersEndIconButton addMotionEffect:group];
    [self.bowlerIconButton addMotionEffect:group];
    [self.interchangeBatsmanButton addMotionEffect:group];
    [self.helpImageView addMotionEffect:group];
    [self.slashRunsOut addMotionEffect:group];
    [self.decimalMainOvers addMotionEffect:group];
    [self.decimalBowlerOvers addMotionEffect:group];
    
    
}

- (void) helpBarButtonTapped:(id) sender
{
    
        [UIView animateWithDuration:0.2 animations:^{
            self.helpImageView.alpha = 1.0;
            self.helpImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpImageViewTapped:)];
            tapGesture.numberOfTapsRequired = 1;
            [self.helpImageView addGestureRecognizer:tapGesture];
        }];
    
}

-(void)helpImageViewTapped:(id) sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.helpImageView.alpha = 0.0;
        self.helpImageView.userInteractionEnabled = NO;
        
    }];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Score Cricket";
    
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    
    if ([currentInnings isEqualToString:@"SecondInnings"]) 
    {
        int score = [[[[self.MatchData objectForKey:@"FirstInnings"] objectForKey:@"Statistics"] objectForKey:@"Score"] integerValue];
        self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings (Target: %d)",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"],score+1];
    }
    else 
    {
        self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"]];    
    }
    
    [self UpdateScoreBoard];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(didEndInnings)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)EditTeam1:(id)sender
{
    [self presentEditTeamWithTableData:[self.MatchData objectForKey:@"Team1"]];
    
}
- (IBAction)EditTeam2:(id)sender
{
    [self presentEditTeamWithTableData:[self.MatchData objectForKey:@"Team2"]];
}

- (void)presentEditTeamWithTableData:(NSMutableDictionary *)teamTableData
{
    DKCEditTeamViewController *editTeam = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTeam"];
    editTeam.delegate=self;
    editTeam.tableData = teamTableData;
    editTeam.fromScoringViewController = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *tempImg = [self blurredBackgroundImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            editTeam.backgroundBlurredImage = tempImg;
        });
    });
    UINavigationController *tempNavController = [[UINavigationController alloc] initWithRootViewController:editTeam];
    tempNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    tempNavController.navigationItem.rightBarButtonItem = UIBarButtonSystemItemDone;
    [self presentModalViewController:tempNavController animated:YES];
}

- (void) dismissEditTeam
{
    [self.team1Button setTitle:[[self.MatchData objectForKey:@"Team1"] objectForKey:@"TeamName"] forState:UIControlStateNormal];
    [self.team2Button setTitle:[[self.MatchData objectForKey:@"Team2"] objectForKey:@"TeamName"] forState:UIControlStateNormal];
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    if ([currentInnings isEqualToString:@"SecondInnings"]) 
    {
        int score = [[[[self.MatchData objectForKey:@"FirstInnings"] objectForKey:@"Statistics"] objectForKey:@"Score"] integerValue];
        self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings (Target: %d)",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"],score+1];
    }
    else 
    {
        self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"]];    
    }
    
    [self UpdateScoreBoard];
}

- (void) UpdateScoreBoard
{
    int runsDigit1Value;
    int runsDigit2Value;
    int runsDigit3Value;
    int wicketsValue;
    int oversDigit1Value;
    int oversDigit2Value;
    int oversDecimalDigitValue;
    
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    
    int score = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Score"] integerValue];
    int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
    
    float oversFloat = (Balls/6)+((Balls%6)/10.0f);
    int overs = oversFloat * 10;
    
    for (int i=0; i<3; i++) 
    {
        if(i==0)
        {
            runsDigit3Value = score%10;
            oversDecimalDigitValue = overs%10;
        }
        else if (i==1) {
            runsDigit2Value = score%10;
            oversDigit2Value = overs%10;
        }
        else {
            runsDigit1Value = score%10;
            oversDigit1Value = overs%10;
        }
        score = score/10;
        overs = overs/10;
    }
    wicketsValue = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wickets"] integerValue];
    
    NSString *batsman1ID = [[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
    NSString *batsman2ID = [[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
    NSString *bowlerID = [[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSMutableDictionary *batsman1Object =[[self.MatchData objectForKey:battingTeam] objectForKey:batsman1ID];
    NSMutableDictionary *batsman2Object =[[self.MatchData objectForKey:battingTeam] objectForKey:batsman2ID];
    NSMutableDictionary *bowler1Object =[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID];
    
    UILabel *runsDigit1Slide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *runsDigit2Slide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *runsDigit3Slide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *wicketsSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *oversDigit1Slide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *oversDigit2Slide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    UILabel *oversDecimalDigitSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, runsDigit1.frame.size.width, runsDigit1.frame.size.height)];
    
    UIButton *batsman1Slide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, batsman1.frame.size.width, batsman1.frame.size.height)];    
    UIButton *batsman2Slide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, batsman1.frame.size.width, batsman1.frame.size.height)];
    UIButton *bowler1Slide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, batsman1.frame.size.width, batsman1.frame.size.height)];
    
    UILabel *batsman1ScoreSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, batsman1Score.frame.size.width, batsman1Score.frame.size.height)];
    UILabel *batsman2ScoreSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, batsman1Score.frame.size.width, batsman1Score.frame.size.height)];
    UILabel *batsman1BallsSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, batsman1Balls.frame.size.width, batsman1Balls.frame.size.height)];
    UILabel *batsman2BallsSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, batsman1Balls.frame.size.width, batsman1Balls.frame.size.height)];
    UILabel *bowler1OversSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bowler1Overs.frame.size.width, bowler1Overs.frame.size.height)];
    UILabel *bowler1OversDecimalSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bowler1Overs.frame.size.width, bowler1Overs.frame.size.height)];
    
    
    runsDigit1Slide.backgroundColor = runsDigit2Slide.backgroundColor = runsDigit3Slide.backgroundColor = wicketsSlide.backgroundColor = oversDigit1Slide.backgroundColor = oversDigit2Slide.backgroundColor = oversDecimalDigitSlide.backgroundColor = [UIColor blackColor];
    
    batsman1Slide.backgroundColor = batsman2Slide.backgroundColor = bowler1Slide.backgroundColor = batsman1.backgroundColor;
    batsman1ScoreSlide.backgroundColor = batsman2ScoreSlide.backgroundColor = batsman1BallsSlide.backgroundColor = batsman2BallsSlide.backgroundColor = bowler1OversSlide.backgroundColor = bowler1OversDecimalSlide.backgroundColor = batsman1Score.backgroundColor;
    
    runsDigit1Slide.textAlignment = runsDigit2Slide.textAlignment = runsDigit3Slide.textAlignment = wicketsSlide.textAlignment = oversDigit1Slide.textAlignment = oversDigit2Slide.textAlignment = oversDecimalDigitSlide.textAlignment = UITextAlignmentCenter;
    
    batsman1ScoreSlide.textAlignment = batsman2ScoreSlide.textAlignment = batsman1BallsSlide.textAlignment = batsman2BallsSlide.textAlignment = bowler1OversSlide.textAlignment = bowler1OversDecimalSlide.textAlignment = batsman1Score.textAlignment;
    
    
    runsDigit1Slide.font = runsDigit2Slide.font = runsDigit3Slide.font = wicketsSlide.font = oversDigit1Slide.font = oversDigit2Slide.font = oversDecimalDigitSlide.font = runsDigit1.font;
    
    batsman1Slide.titleLabel.font = batsman2Slide.titleLabel.font = bowler1Slide.titleLabel.font = batsman1.titleLabel.font;
    batsman1ScoreSlide.font = batsman2ScoreSlide.font = batsman1BallsSlide.font = batsman2BallsSlide.font = bowler1OversSlide.font = bowler1OversDecimalSlide.font = batsman1Score.font;
    
    runsDigit1Slide.textColor = runsDigit2Slide.textColor = runsDigit3Slide.textColor = wicketsSlide.textColor = oversDigit1Slide.textColor = oversDigit2Slide.textColor = oversDecimalDigitSlide.textColor = [UIColor whiteColor];
    
    batsman1Slide.titleLabel.textColor = batsman2Slide.titleLabel.textColor = bowler1Slide.titleLabel.textColor = batsman1.titleLabel.textColor;
    batsman1ScoreSlide.textColor = batsman2ScoreSlide.textColor = batsman1BallsSlide.textColor = batsman2BallsSlide.textColor = bowler1OversSlide.textColor = bowler1OversDecimalSlide.textColor = batsman1Score.textColor;
    
    
    runsDigit1Slide.text = runsDigit1.text;
    runsDigit1.text = [NSString stringWithFormat:@"%d",runsDigit1Value];
    [runsDigit1 addSubview:runsDigit1Slide];
    runsDigit2Slide.text = runsDigit2.text;
    runsDigit2.text = [NSString stringWithFormat:@"%d",runsDigit2Value];
    [runsDigit2 addSubview:runsDigit2Slide];
    runsDigit3Slide.text = runsDigit3.text;
    runsDigit3.text = [NSString stringWithFormat:@"%d",runsDigit3Value];
    [runsDigit3 addSubview:runsDigit3Slide];
    
    wicketsSlide.text = wickets.text;
    wickets.text = [NSString stringWithFormat:@"%d",wicketsValue];
    [wickets addSubview:wicketsSlide];
    
    oversDigit1Slide.text = oversDigit1.text;
    oversDigit1.text = [NSString stringWithFormat:@"%d",oversDigit1Value];
    [oversDigit1 addSubview:oversDigit1Slide];
    oversDigit2Slide.text = oversDigit2.text;
    oversDigit2.text = [NSString stringWithFormat:@"%d",oversDigit2Value];
    [oversDigit2 addSubview:oversDigit2Slide];
    oversDecimalDigitSlide.text = oversDecimalDigit.text;
    oversDecimalDigit.text = [NSString stringWithFormat:@"%d",oversDecimalDigitValue];
    [oversDecimalDigit addSubview:oversDecimalDigitSlide];
    
    [batsman1Slide setTitle:batsman1.currentTitle forState:UIControlStateNormal];
    [batsman1 addSubview:batsman1Slide];
    [batsman2Slide setTitle:batsman2.currentTitle forState:UIControlStateNormal];
    [batsman2 addSubview:batsman2Slide];
    [bowler1Slide setTitle:bowler1.currentTitle forState:UIControlStateNormal];
    [bowler1 addSubview:bowler1Slide];
    
    batsman1ScoreSlide.text = batsman1Score.text;
    [batsman1Score addSubview:batsman1ScoreSlide];
    batsman2ScoreSlide.text = batsman2Score.text;
    [batsman2Score addSubview:batsman2ScoreSlide];
    batsman1BallsSlide.text = batsman1Balls.text;
    [batsman1Balls addSubview:batsman1BallsSlide];
    batsman2BallsSlide.text = batsman2Balls.text;
    [batsman2Balls addSubview:batsman2BallsSlide];
    bowler1OversSlide.text = bowler1Overs.text;
    [bowler1Overs addSubview:bowler1OversSlide];
    bowler1OversDecimalSlide.text = bowler1OversDecimal.text;
    [bowler1OversDecimal addSubview:bowler1OversDecimalSlide];
    
    
    [batsman1 setTitle:[batsman1Object objectForKey:@"Name"] forState:UIControlStateNormal];
    [batsman2 setTitle:[batsman2Object objectForKey:@"Name"] forState:UIControlStateNormal];
    [bowler1 setTitle:[bowler1Object objectForKey:@"Name"] forState:UIControlStateNormal];
    
    batsman1Score.text = [[[batsman1Object objectForKey:@"Batting"] objectForKey:@"Score"] stringValue];
    batsman1Balls.text = [NSString stringWithFormat:@"(%@)",[[[batsman1Object objectForKey:@"Batting"] objectForKey:@"Balls"] stringValue]];
    batsman2Score.text = [[[batsman2Object objectForKey:@"Batting"] objectForKey:@"Score"] stringValue];
    batsman2Balls.text = [NSString stringWithFormat:@"(%@)",[[[batsman2Object objectForKey:@"Batting"] objectForKey:@"Balls"] stringValue]];
    bowler1Overs.text=[NSString stringWithFormat:@"%d",[[[bowler1Object objectForKey:@"Bowling"] objectForKey:@"Balls"] integerValue]/6 ];
    bowler1OversDecimal.text=[NSString stringWithFormat:@"%d",[[[bowler1Object objectForKey:@"Bowling"] objectForKey:@"Balls"] integerValue]%6 ];
    
        
        
    [UIView animateWithDuration:1.0 animations:^{
        runsDigit1Slide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        runsDigit2Slide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        runsDigit3Slide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        
        wicketsSlide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        
        oversDigit1Slide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        oversDigit2Slide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        oversDecimalDigitSlide.frame = CGRectMake(0, -runsDigit1.frame.size.height, runsDigit1.frame.size.width, runsDigit1.frame.size.height);
        
        batsman1Slide.frame = CGRectMake(0, -batsman1.frame.size.height, batsman1.frame.size.width, batsman1.frame.size.height);
        batsman2Slide.frame = CGRectMake(0, -batsman1.frame.size.height, batsman1.frame.size.width, batsman1.frame.size.height);
        bowler1Slide.frame = CGRectMake(0, -batsman1.frame.size.height, batsman1.frame.size.width, batsman1.frame.size.height);
        
        
        batsman1ScoreSlide.frame = CGRectMake(0, -batsman1Score.frame.size.height, batsman1Score.frame.size.width, batsman1Score.frame.size.height);
        batsman2ScoreSlide.frame = CGRectMake(0, -batsman1Score.frame.size.height, batsman1Score.frame.size.width, batsman1Score.frame.size.height);
        batsman1BallsSlide.frame = CGRectMake(0, -batsman1Balls.frame.size.height, batsman1Balls.frame.size.width, batsman1Balls.frame.size.height);
        batsman2BallsSlide.frame = CGRectMake(0, -batsman1Balls.frame.size.height, batsman1Balls.frame.size.width, batsman1Balls.frame.size.height);
        bowler1OversSlide.frame =  CGRectMake(0, -bowler1Overs.frame.size.height, bowler1Overs.frame.size.width, bowler1Overs.frame.size.height);
        bowler1OversDecimalSlide.frame =  CGRectMake(0, -bowler1Overs.frame.size.height, bowler1Overs.frame.size.width, bowler1Overs.frame.size.height);
        
        
    }completion:^(BOOL finished)
     {
         [runsDigit1Slide removeFromSuperview];
         [runsDigit2Slide removeFromSuperview];
         [runsDigit3Slide removeFromSuperview];
         
         [wicketsSlide removeFromSuperview];
         
         [oversDigit1Slide removeFromSuperview];
         [oversDigit2Slide removeFromSuperview];
         [oversDecimalDigitSlide removeFromSuperview];
         
         [batsman1Slide removeFromSuperview];
         [batsman2Slide removeFromSuperview];
         [bowler1Slide  removeFromSuperview];
         
         [batsman1ScoreSlide removeFromSuperview];
         [batsman2ScoreSlide removeFromSuperview];
         [batsman1BallsSlide removeFromSuperview];
         [batsman2BallsSlide removeFromSuperview];
         [bowler1OversSlide removeFromSuperview];
         [bowler1OversDecimalSlide removeFromSuperview];
         
     }];
    score = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"]objectForKey:@"Score"] integerValue];
    if (Balls == 0) 
    {
        self.runRate.text = @"Run Rate: 0";
    }
    else 
    {
        self.runRate.text = [NSString stringWithFormat:@"Run Rate: %0.02f",(float)((float)(score*6)/Balls)];
    }
    int currentExtras = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Extras"] intValue];
    self.runRate.text = [NSString stringWithFormat:@"%@   %@",self.runRate.text,[NSString stringWithFormat:@"Extras: %d",currentExtras]];
    
    NSMutableString *runsInOver = [[NSMutableString alloc] initWithString:@"This Over:"];
    int oldBalls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] intValue];
    NSArray *overRunsArray = [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",(oldBalls/6)+1]];
    
    for (NSString *tempRuns in overRunsArray)
    {
        NSString *tempString=nil;
        if (tempRuns.length > 0)
        {
            tempString= [tempRuns substringWithRange:NSMakeRange(0, 1)];
        }
        
        if (![tempString isEqualToString:@"P"])
        {
            [runsInOver appendString:[NSString stringWithFormat:@" %@",tempRuns]];
        }
    }
    self.thisOverRuns.text = runsInOver;
    [DKCCreatePList CreatePlistDictionaryWithName:[self.MatchData objectForKey:@"FileName"] withData:self.MatchData];
    
    
}

-(void)AddRuns:(int)runs andIsSameBall:(BOOL)isSameBall andFromOut:(BOOL)fromOut
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    
    
    //Update Main Score
    NSNumber *newScore= [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Score"] intValue] + runs ];
    [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newScore forKey:@"Score"];
    
    int oldBalls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] intValue];
    NSNumber *newBalls=[NSNumber numberWithInt:oldBalls + 1 ];
    
    if(!isSameBall)
    {
        
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newBalls forKey:@"Balls"];
    }
    NSNumber *MainRunTypeCount = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:[NSString stringWithFormat:@"%d",runs]] intValue] + 1 ];
    [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:MainRunTypeCount forKey:[NSString stringWithFormat:@"%d",runs]];
    
    //Batsmanid and bowlerid
    NSString *forBowlerString;
    NSString *forBatsmanString;
    if(!isSameBall)
    {
        forBatsmanString = @"OnStrike";
        forBowlerString = @"Bowler";
    }
    else
    {
        forBatsmanString = @"LastBallOnStrike";
        forBowlerString = @"LastBallBowler";
    }
    NSString *batsmanID = [[self.MatchData objectForKey:currentInnings] objectForKey:forBatsmanString];
    NSString *bowlerID = [[self.MatchData objectForKey:currentInnings] objectForKey:forBowlerString];
    
    //Add bowler id at the front of an over
    if(oldBalls%6 == 0 && !isSameBall) //do it only if its new ball
    {
        [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",([newBalls intValue]/6)+1]] addObject:bowlerID];
    }
    //Add runs to overs
    if (isSameBall) //if same ball then add to previous ball
    {
        NSMutableArray *currentOver = [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",((oldBalls-1)/6)+1]];
        NSString *currentOverBall = [currentOver objectAtIndex:[currentOver count]-1];
        
        [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",((oldBalls-1)/6)+1]] replaceObjectAtIndex:[currentOver count]-1 withObject:[NSString stringWithFormat:@"%@+%d",currentOverBall,runs]];
    }
    else 
    {
        if (fromOut)
        {
            [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",(oldBalls/6)+1]] addObject:[NSString stringWithFormat:@"%dW",runs]];
        }
        else
        {
            [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",(oldBalls/6)+1]] addObject:[NSString stringWithFormat:@"%d",runs]];
        }
        
    }
    
    
    
    //Add Batsman score and Balls
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSMutableDictionary *batsmanObject =[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID];
    NSMutableDictionary *bowlerObject =[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID];
    NSNumber *newBatsmanScore = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:@"Score"] intValue] + runs];
    NSNumber *newBatsmanBalls = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:@"Balls"] intValue] + 1];
    NSNumber *BatsManRunTypeCount = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:[NSString stringWithFormat:@"%d",runs]] intValue] + 1];
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:newBatsmanScore forKey:@"Score"];
    if(!isSameBall)
    {
        [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:newBatsmanBalls forKey:@"Balls"];
    }
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:BatsManRunTypeCount forKey:[NSString stringWithFormat:@"%d",runs]];
    
    //Add Bowlers Runs and Balls
    NSNumber *newBowlerRuns = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Runs"] intValue] + runs];
    NSNumber *newBowlerBalls = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Balls"] intValue] + 1];
    NSNumber *BowlerRunTypeCount = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:[NSString stringWithFormat:@"%d",runs]] intValue] + 1];
    [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:newBowlerRuns forKey:@"Runs"];
    if(!isSameBall)
    {
        [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:newBowlerBalls forKey:@"Balls"];
    }
        
    [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:BowlerRunTypeCount forKey:[NSString stringWithFormat:@"%d",runs]];
    
    if ([newBalls intValue] == 1) 
    {
        int battingOrderCount=[[[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingOrderCount"] intValue];
        int bowlingOrderCount = [[[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingOrderCount"] intValue];
        
        NSString *batTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
       NSString *onStrikeEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
        
        NSString *bowlTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
        NSString *curbowler=[[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"];
        
        [[[self.MatchData objectForKey:batTeam] objectForKey:onStrikeEndBatsman] setObject:[NSNumber numberWithInt:battingOrderCount++] forKey:@"BattingOrder"];
        [[[self.MatchData objectForKey:batTeam] objectForKey:runnersEndBatsman] setObject:[NSNumber numberWithInt:battingOrderCount++] forKey:@"BattingOrder"];
        [[self.MatchData objectForKey:currentInnings] setObject:[NSNumber numberWithInt:battingOrderCount] forKey:@"BattingOrderCount"];
        
        [[[self.MatchData objectForKey:bowlTeam] objectForKey:curbowler] setObject:[NSNumber numberWithInt:bowlingOrderCount++] forKey:@"BowlingOrder"];
        [[self.MatchData objectForKey:currentInnings] setObject:[NSNumber numberWithInt:bowlingOrderCount] forKey:@"BowlingOrderCount"];
    }
    
    //Odd Number change batsman ends
    if(runs%2!=0)
    {
        NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        if(!isSameBall)
        {
            [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
        }
        [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];
    }
    else 
    {
        NSString *onStrikeBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        if(!isSameBall)
        {
            [[self.MatchData objectForKey:currentInnings] setObject:onStrikeBatsman forKey:@"LastBallOnStrike"];
        }
    }
    //Overs Up
    if(([newBalls intValue]%6==0 && !isSameBall)|| (oldBalls%6==0 && isSameBall))
    {
        //Exchange Batsman
        NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];
        
        if(!isSameBall)
        {
            if(!fromOut)
            {
                int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
                float oversFloat = (Balls/6)+((Balls%6)/10.0f);
                if(oversFloat >= [[self.MatchData objectForKey:@"Overs"] floatValue])
                {
                    [self EndInnings:nil];
                    return;
                }
                else 
                {
                    [self performSelector:@selector(ChangeBowler:) withObject:nil afterDelay:1];
                    return;
                }
            }
            /*[[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"] forKey:@"LastBallBowler"];
            if(([newBalls intValue]/6)%2!=0)
            {
                //Exchange Bowlers
                [[self.MatchData objectForKey:currentInnings] setObject:@"P10" forKey:@"Bowler"];
            }
            else 
            {
                //Exchange Bowlers
                [[self.MatchData objectForKey:currentInnings] setObject:@"P11" forKey:@"Bowler"];
            }*/
        }
        
    }
    if(!fromOut)
    {
        int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
        float oversFloat = (Balls/6)+((Balls%6)/10.0f);
        if(oversFloat >= [[self.MatchData objectForKey:@"Overs"] floatValue])
        {
            [self EndInnings:nil];
        }
    }

}

-(IBAction)InterchangeBatsman:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
    //[[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
    [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
    [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];
    [self UpdateScoreBoard];
}

- (void) AddExtra:(NSString *)extraType andRuns:(int)runs andRunsFromBat:(BOOL)isRunsFromBat andIsOut:(BOOL)isOut
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    int extraRun = 0;
    if([extraType isEqualToString:@"noball"]||[extraType isEqualToString:@"wide"])
    {
        extraRun = 1;
    }
    
    //Update Main Score
    NSNumber *newScore= [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Score"] intValue] + extraRun + runs];
    [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newScore forKey:@"Score"];
    
    int oldBalls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] intValue];
    
    NSNumber *newBalls;
    if([extraType isEqualToString:@"bye"]||[extraType isEqualToString:@"legbye"])
    {
        newBalls=[NSNumber numberWithInt:oldBalls + 1 ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newBalls forKey:@"Balls"];
    }
    else 
    {
        newBalls=[NSNumber numberWithInt:oldBalls ];
    }
    
    if(runs > 0)
    {
        //update runtype count
        NSNumber *MainRunTypeCount = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:[NSString stringWithFormat:@"%d",runs]] intValue] + 1 ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:MainRunTypeCount forKey:[NSString stringWithFormat:@"%d",runs]];
    }
    
    //update innings Extras
    NSNumber *newExtras = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Extras"] intValue] + extraRun + runs ];
    [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newExtras forKey:@"Extras"];
    
    if([extraType isEqualToString:@"noball"])
    {
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"NoBalls"] intValue] + extraRun + runs ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:tempExtra forKey:@"NoBalls"];
    }
    else if ([extraType isEqualToString:@"wide"]) {
        
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wides"] intValue] + extraRun + runs ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:tempExtra forKey:@"Wides"];
    }
    else if ([extraType isEqualToString:@"bye"]) {
        
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Byes"] intValue] + extraRun + runs ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:tempExtra forKey:@"Byes"];
    }
    else if ([extraType isEqualToString:@"legbye"]) {
        
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"LegByes"] intValue] + extraRun + runs ];
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:tempExtra forKey:@"LegByes"];
    }
    
    //Batsmanid and bowlerid
    NSString *forBowlerString;
    NSString *forBatsmanString;
    forBatsmanString = @"OnStrike";
    forBowlerString = @"Bowler";
    
    NSString *batsmanID = [[self.MatchData objectForKey:currentInnings] objectForKey:forBatsmanString];
    NSString *bowlerID = [[self.MatchData objectForKey:currentInnings] objectForKey:forBowlerString];
    
    //Add bowler id at the front of an over  **** Have to Think about it ******
    if(oldBalls%6 == 0) //do it only if its new ball
    {
        [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",( (oldBalls +1 )/6)+1]] addObject:bowlerID];
    }
   //Add extras for that over
    NSString *oversExtras;
    if (isOut)
    {
        oversExtras = [NSString stringWithFormat:@"%d%@W",runs,extraType];
    }
    else
    {
        oversExtras = [NSString stringWithFormat:@"%d%@",runs,extraType];
    }
    
    [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Overs"] objectForKey:[NSString stringWithFormat:@"%d",(oldBalls/6)+1]] addObject:oversExtras];
    
    
    //Add Batsman score and Balls
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSMutableDictionary *batsmanObject =[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID];
    NSMutableDictionary *bowlerObject =[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID];
    
    NSNumber *newBatsmanScore;    
    NSNumber *newBatsmanBalls;

    if([extraType isEqualToString:@"noball"])
    {
        if (isRunsFromBat || runs == 0 || (!isRunsFromBat && runs >0)) 
        {
            int batsmanRuns = runs;
            if((!isRunsFromBat && runs >0))
            {
                batsmanRuns = 0;
            }
            
            newBatsmanScore = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:@"Score"] intValue] + batsmanRuns];
            newBatsmanBalls = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:@"Balls"] intValue] + 1];
            NSNumber *BatsManRunTypeCount = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:[NSString stringWithFormat:@"%d",batsmanRuns]] intValue] + 1];
            [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:newBatsmanScore forKey:@"Score"];
            [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:newBatsmanBalls forKey:@"Balls"];
            [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:BatsManRunTypeCount forKey:[NSString stringWithFormat:@"%d",batsmanRuns]];
        }
        
    }
    else 
    {
        newBatsmanScore = [[batsmanObject objectForKey:@"Batting"]objectForKey:@"Score"];
    }
    
    if([extraType isEqualToString:@"bye"]||[extraType isEqualToString:@"legbye"])
    {
        newBatsmanBalls = [NSNumber numberWithInt:[[[batsmanObject objectForKey:@"Batting"]objectForKey:@"Balls"] intValue] + 1];
        [[[[self.MatchData objectForKey:battingTeam] objectForKey:batsmanID] objectForKey:@"Batting"] setObject:newBatsmanBalls forKey:@"Balls"];
    }
    else 
    {
        newBatsmanBalls = [[batsmanObject objectForKey:@"Batting"]objectForKey:@"Balls"];
    }
    
    
    //Add Bowlers Runs and Balls
	if(![extraType isEqualToString:@"bye"]&& ![extraType isEqualToString:@"legbye"])
    {
		NSNumber *newBowlerRuns = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Runs"] intValue] + runs + extraRun];
		[[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:newBowlerRuns forKey:@"Runs"];
	}
    
    NSNumber *newBowlerBalls;
    if([extraType isEqualToString:@"bye"]||[extraType isEqualToString:@"legbye"])
    {
        newBowlerBalls = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Balls"] intValue] + 1];
        [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:newBowlerBalls forKey:@"Balls"];
    }
    else 
    {
        newBowlerBalls = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Balls"] intValue]];
    }
   
    
    //update Bowler Extras
    NSNumber *bowlExtra = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Extras"] intValue] + extraRun + runs ];
    [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:bowlExtra forKey:@"Extras"];
    
    if([extraType isEqualToString:@"noball"])
    {
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"NoBalls"] intValue] + extraRun + runs ];
        [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:tempExtra forKey:@"NoBalls"];
    }
    else if ([extraType isEqualToString:@"wide"]) {
        
        NSNumber *tempExtra = [NSNumber numberWithInt:[[[bowlerObject objectForKey:@"Bowling"]objectForKey:@"Wides"] intValue] + extraRun + runs ];
        [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:tempExtra forKey:@"Wides"];
    }
   
    
    
    //Odd Number change batsman ends
    if(runs%2!=0)
    {
        NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];
    }
    else 
    {
        NSString *onStrikeBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:onStrikeBatsman forKey:@"LastBallOnStrike"];
    }
    
    //Overs Up
    if(([newBalls intValue]%6==0 && ([extraType isEqualToString:@"bye"]||[extraType isEqualToString:@"legbye"])))
    {
        //Exchange Batsman
        NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
        [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];
        //[self ChangeBowler:nil];
        int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
        float oversFloat = (Balls/6)+((Balls%6)/10.0f);
        if(oversFloat >= [[self.MatchData objectForKey:@"Overs"] floatValue])
        {
            [self EndInnings:nil];
        }
        else 
        {
            if(isOut)
            {
                [self OutActionFromExtra:YES andExtraType:extraType];
            }
            else 
            {
                [self ChangeBowler:nil];
            }
        }

        
    }
    else if(isOut)
    {
        [self OutActionFromExtra:YES andExtraType:extraType];
    }

    
}


- (IBAction)Run0:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    
    [self AddRuns:0 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];
}
- (IBAction)Run1:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self AddRuns:1 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];

}
- (IBAction)Run2:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self AddRuns:2 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];
    
}
- (IBAction)Run3:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self AddRuns:3 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];
}
- (IBAction)Run4:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self AddRuns:4 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];
}
- (IBAction)Run6:(id)sender
{
    [self AddRuns:6 andIsSameBall:NO andFromOut:NO];
    [self UpdateScoreBoard];
}
- (IBAction)RunPlus:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    /*NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    int oldBalls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] intValue];
    if(oldBalls > 0)
    {
        [self AddRuns:1 andIsSameBall:YES andFromOut:NO];
        [self UpdateScoreBoard];
    }*/
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"Runs" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"5",@"7", nil];
    Sheet.tag = 2;
    Sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [Sheet showInView:self.view];
}

- (IBAction)legByeExtra:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self PresentAdditionalRunsView:@"legbye"];   
}
- (IBAction)byeExtra:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self PresentAdditionalRunsView:@"bye"];    
}
- (IBAction)wideExtra:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self PresentAdditionalRunsView:@"wide"];    
}
- (IBAction)noBallExtra:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self PresentAdditionalRunsView:@"noball"];
}

-(void)PresentAdditionalRunsView:(NSString *)ExtraType
{
    DKCAdditionalRunsViewController *tempAddRuns = [self.storyboard instantiateViewControllerWithIdentifier:@"AdditionalRunsViewController"];
    tempAddRuns.delegate=self;
    tempAddRuns.ExtraType = ExtraType;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *tempImg = [self blurredBackgroundImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            tempAddRuns.backgroundBlurImage = tempImg;
        });
    });
    [self presentModalViewController:tempAddRuns animated:YES];
    
}

- (IBAction)undoLastBall:(id)sender
{
    if(head >0)
    {
        self.MatchData = [[self.stackUndo objectAtIndex:head-1] mutableDeepCopy];
        [self.stackUndo removeObjectAtIndex:head-1];
        head--;
        [self UpdateScoreBoard];
    }
    
}
- (IBAction)EndInnings:(id)sender
{
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"End Innings cannot be undone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Confirm End Innings", nil];
    Sheet.tag = 1;
    Sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [Sheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1)//if end innings action sheet
    {
        if (buttonIndex ==0) 
        {
            if([[self.MatchData objectForKey:@"CurrentInnings"] isEqualToString:@"FirstInnings"])
            {
                [self.MatchData setObject:@"SecondInnings" forKey:@"CurrentInnings"];
                [self UpdateScoreBoard];
                NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
                NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
                int score = [[[[self.MatchData objectForKey:@"FirstInnings"] objectForKey:@"Statistics"] objectForKey:@"Score"] integerValue];
                self.inningTitle.text = [NSString stringWithFormat:@"%@ Innings (Target: %d)",[[self.MatchData objectForKey:battingTeam] objectForKey:@"TeamName"],score+1];
                self.MatchDataCopy = [self.MatchData mutableDeepCopy];
                [DKCCreatePList CreatePlistDictionaryWithName:[self.MatchData objectForKey:@"FileName"] withData:self.MatchData];
            }
            else {
                [DKCCreatePList CreatePlistDictionaryWithName:[self.MatchData objectForKey:@"FileName"] withData:self.MatchData];
                NSMutableArray *listOfmatches = [DKCCreatePList GetListOfMatches];
                for (NSMutableDictionary *tempMatch in listOfmatches) 
                {
                    if([[tempMatch objectForKey:@"FileName"] isEqualToString:[self.MatchData objectForKey:@"FileName"]])
                    {
                        [tempMatch setObject:@"completed" forKey:@"isCurrent"];
                        break;
                    }
                }
                [DKCCreatePList RefreshMatchesListWithNewData:listOfmatches];
                didEndInnings = YES;
                [self showScoreBoard:nil];
            }
        }
    }
    if(actionSheet.tag == 2)//if end innings action sheet
    {
        if (buttonIndex ==0) 
        {
            [self AddRuns:5 andIsSameBall:NO andFromOut:NO];
        }
        else if (buttonIndex ==1) 
        {
            [self AddRuns:7 andIsSameBall:NO andFromOut:NO];
        }
        [self UpdateScoreBoard];
    }
}

-(IBAction)showScoreBoard:(id)sender
{
    DKCScoreCardViewController *scoreCard = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewController"];
    scoreCard.MatchData = self.MatchData;
    scoreCard.currentInnings = @"FirstInnings";
    UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:scoreCard];
    tempNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    scoreCard.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTappedForScoreCardViewController)];
    [self presentViewController:tempNav animated:YES completion:NULL];
}

- (void)doneTappedForScoreCardViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)OutAction:(id)sender
{
    [self OutActionFromExtra:NO andExtraType:nil];
}

-(void)OutActionFromExtra:(BOOL)FromExtra andExtraType:(NSString *)extraType
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    DKCOutViewController *outViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OutViewController"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *tempImg = [self blurredBackgroundImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            outViewController.backgroundBlurImage = tempImg;
        });
    });
    
    
    outViewController.delegate = self;
    outViewController.by = [self.MatchData objectForKey:bowlingTeam];
    outViewController.who = [self.MatchData objectForKey:battingTeam];
    outViewController.onStrike = [[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
    outViewController.runnersEnd = [[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
    if (FromExtra) 
    {
        outViewController.isFromExtras = YES;
        outViewController.extraType = extraType;
        [self presentViewController:outViewController animated:YES completion:NULL];
    }
    else 
    {
       [self presentViewController:outViewController animated:YES completion:NULL];
    }
    
}
         
- (void) presentModalViewController:(UIViewController *)modalViewController 
{
    [self presentModalViewController:modalViewController animated:YES];          
}

- (void) OutAction:(int)addRuns andOutType:(NSString *)outType andOutBatsman:(NSString *)outBatsman andOutBy:(NSString *)outByFielder
{
    
}

-(IBAction)ChangeBowler:(id)sender
{
    if (sender!=nil) 
    {
        [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
        head++;
        if(head > maxUndo)
        {
            [self.stackUndo removeObjectAtIndex:0];
            head--;
        }
    }
    DKCSelectBowlerViewController *selectBowler = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBowlerViewController"];
    selectBowler.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *tempImg = [self blurredBackgroundImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            selectBowler.backgroundBlurImage = tempImg;
        });
    });
    if (sender==nil) //if overup and called to this function
    {
        selectBowler.hardStop = YES;
    }
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    selectBowler.bowlers = [self.MatchData objectForKey:bowlingTeam];
    selectBowler.currentBowler = [[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"];
    [self presentModalViewController:selectBowler animated:YES];
}

- (void)bowlerSelected:(NSString *)newBowler
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"] forKey:@"LastBallBowler"];
    [[self.MatchData objectForKey:currentInnings] setObject:newBowler forKey:@"Bowler"];
    [self UpdateScoreBoard];
    
    
    //Add Bowling order to the bowler
    int bowlingOrderCount = [[[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingOrderCount"] intValue];
    NSString *bowlTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    if([[[[self.MatchData objectForKey:bowlTeam] objectForKey:newBowler] objectForKey:@"BowlingOrder"] intValue] == 13)
    {
         [[[self.MatchData objectForKey:bowlTeam] objectForKey:newBowler] setObject:[NSNumber numberWithInt:bowlingOrderCount++] forKey:@"BowlingOrder"];
         [[self.MatchData objectForKey:currentInnings] setObject:[NSNumber numberWithInt:bowlingOrderCount] forKey:@"BowlingOrderCount"];
    }
}

-(IBAction)ChangeOnStrikeBatsman:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self ChangeBatsman:TRUE];
}
-(IBAction)ChangeRunnersEndBatsman:(id)sender
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    [self ChangeBatsman:FALSE];    
}

- (void)ChangeBatsman:(BOOL)isOnStrike
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    int Inningswickets = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wickets"] integerValue];
    if(Inningswickets != 9)
    {
        DKCSelectBatsmanViewController *selectBatsman = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBatsmanViewController"];
        selectBatsman.delegate = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *tempImg = [self blurredBackgroundImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                selectBatsman.backgroundBlurImage = tempImg;
            });
        });
        NSString *oldBatsman = isOnStrike?[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"]:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
        
        selectBatsman.batsmans = [self.MatchData objectForKey:battingTeam];
        selectBatsman.onStrikeBatsman = [[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        selectBatsman.runnersEndBatsman = [[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
        selectBatsman.changeBatsman = TRUE;
        
        selectBatsman.forBatsmanChange = oldBatsman;
        
        [self presentModalViewController:selectBatsman animated:YES];
    }
    
    
}

- (void)ChangeBatsmanAfterOut:(NSMutableDictionary *)outData
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    
    int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
    Balls = Balls +1;
    float oversFloat = (Balls/6)+((Balls%6)/10.0f);
    int Inningswickets = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wickets"] integerValue];
    
    
    if(Inningswickets == 9 || oversFloat >= [[self.MatchData objectForKey:@"Overs"] floatValue])
    {
        NSString *outType = [outData objectForKey:@"outType"];
        if (([outData objectForKey:@"isFromExtras"] == NULL || ((NSString *)[outData objectForKey:@"isFromExtras"]).length == 0) && ![outType isEqualToString:@"Timed Out"] )  
        {
           [self AddRuns:[[outData objectForKey:@"addRuns"] intValue] andIsSameBall:NO andFromOut:YES]; 
        }
        
        NSString *bowlerID = [outData objectForKey:@"outByBowler"];
        NSNumber *bowlerWickets = [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] objectForKey:@"Wickets"];
        
        if( ![outType isEqualToString:@"Timed Out"] && ![outType isEqualToString:@"Obstructing Field"]&&![outType isEqualToString:@"Run Out"])
        {
            [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:[NSNumber numberWithInt:1+[bowlerWickets intValue]] forKey:@"Wickets"];
        }
        
        [[[[self.MatchData objectForKey:battingTeam] objectForKey:[outData objectForKey:@"outBatsman"]] objectForKey:@"Batting"] setObject:[outData objectForKey:@"outType"] forKey:@"OutType"];
        [[[[self.MatchData objectForKey:battingTeam] objectForKey:[outData objectForKey:@"outBatsman"]] objectForKey:@"Batting"] setObject:[outData objectForKey:@"outByFielder"] forKey:@"OutByFielder"];
        [[[[self.MatchData objectForKey:battingTeam] objectForKey:[outData objectForKey:@"outBatsman"]] objectForKey:@"Batting"] setObject:bowlerID forKey:@"OutByBowler"];
        
        NSNumber *newWickets = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wickets"] intValue] +1] ;
        [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newWickets forKey:@"Wickets"];
         [self EndInnings:nil];
        
        return;

    }
    else 
    {
        DKCSelectBatsmanViewController *selectBatsman = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBatsmanViewController"];
        selectBatsman.delegate = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *tempImg = [self blurredBackgroundImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                selectBatsman.backgroundBlurImage = tempImg;
            });
        });
        NSString *oldBatsman = [outData objectForKey:@"outBatsman"];
        selectBatsman.outData = outData;
        selectBatsman.batsmans = [self.MatchData objectForKey:battingTeam];
        selectBatsman.onStrikeBatsman = [[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
        selectBatsman.runnersEndBatsman = [[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"];
        selectBatsman.changeBatsman = FALSE;
        
        selectBatsman.forBatsmanChange = oldBatsman;
        
        [self presentModalViewController:selectBatsman animated:YES];
    }
    
}


-(void) batsmanSelected:(NSString *)newBatsman andForBatsman:(NSString *)oldBatsman andOutType:(NSString *)oldBatsmanOutType
{
    [self dismissViewControllerAnimated:YES completion:NULL];
     NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:oldBatsman] objectForKey:@"Batting"] setObject:oldBatsmanOutType forKey:@"OutType"];
    NSString *strikeOrRunnersend;
    if ([[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"] isEqualToString: oldBatsman]) 
    {
        strikeOrRunnersend = @"OnStrike";
    }
    else 
    {
        strikeOrRunnersend = @"RunnersEnd";
    }
    
    [[self.MatchData objectForKey:currentInnings] setObject:newBatsman forKey:strikeOrRunnersend];
    [self UpdateScoreBoard];
   
    
    //Add Batting order
    int battingOrderCount=[[[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingOrderCount"] intValue];
    
    NSString *batTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    if([[[[self.MatchData objectForKey:batTeam] objectForKey:newBatsman] objectForKey:@"BattingOrder"] intValue] == 13)
    {
        [[[self.MatchData objectForKey:batTeam] objectForKey:newBatsman] setObject:[NSNumber numberWithInt:battingOrderCount++] forKey:@"BattingOrder"];
        [[self.MatchData objectForKey:currentInnings] setObject:[NSNumber numberWithInt:battingOrderCount] forKey:@"BattingOrderCount"];
    }

    
}


-(void) batsmanSelectedAfterOut:(NSString *)newBatsman andForBatsman:(NSString *)oldBatsman  andOutData:(NSMutableDictionary *)outData
{
    [self.stackUndo addObject: [self.MatchData mutableDeepCopy]];
    head++;
    if(head > maxUndo)
    {
        [self.stackUndo removeObjectAtIndex:0];
        head--;
    }
    NSString *outType = [outData objectForKey:@"outType"];
    if (([outData objectForKey:@"isFromExtras"] == NULL || ((NSString *)[outData objectForKey:@"isFromExtras"]).length == 0) && ![outType isEqualToString:@"Timed Out"] )  
    {
        [self AddRuns:[[outData objectForKey:@"addRuns"] intValue] andIsSameBall:NO andFromOut:YES];
    }
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSString *battingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    NSString *bowlingTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BowlingTeam"];
    NSString *bowlerID = [outData objectForKey:@"outByBowler"];
    NSNumber *bowlerWickets = [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] objectForKey:@"Wickets"];
    if( ![outType isEqualToString:@"Timed Out"] && ![outType isEqualToString:@"Obstructing Field"]&&![outType isEqualToString:@"Run Out"])
    {
        [[[[self.MatchData objectForKey:bowlingTeam] objectForKey:bowlerID] objectForKey:@"Bowling"] setObject:[NSNumber numberWithInt:1+[bowlerWickets intValue]] forKey:@"Wickets"];
    }
    
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:oldBatsman] objectForKey:@"Batting"] setObject:[outData objectForKey:@"outType"] forKey:@"OutType"];
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:oldBatsman] objectForKey:@"Batting"] setObject:[outData objectForKey:@"outByFielder"] forKey:@"OutByFielder"];
    [[[[self.MatchData objectForKey:battingTeam] objectForKey:oldBatsman] objectForKey:@"Batting"] setObject:bowlerID forKey:@"OutByBowler"];

    NSNumber *newWickets = [NSNumber numberWithInt:[[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Wickets"] intValue] +1] ;
    [[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] setObject:newWickets forKey:@"Wickets"];
    
    NSString *strikeOrRunnersend;
    if ([[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"] isEqualToString: oldBatsman]) 
    {
        strikeOrRunnersend = @"OnStrike";
    }
    else 
    {
        strikeOrRunnersend = @"RunnersEnd";
    }
    [[self.MatchData objectForKey:currentInnings] setObject:newBatsman forKey:strikeOrRunnersend];
    if(![[outData objectForKey:@"outOnStrikeBatsman"] isEqualToString:@"New Batsman"])
    {
        if([strikeOrRunnersend isEqualToString:@"OnStrike"])
        {
            //Exchange Batsman
            NSString *runnersEndBatsman=[[self.MatchData objectForKey:currentInnings] objectForKey:@"OnStrike"];
            [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"LastBallOnStrike"];
            [[self.MatchData objectForKey:currentInnings] setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"RunnersEnd"] forKey:@"OnStrike"];
            [[self.MatchData objectForKey:currentInnings] setObject:runnersEndBatsman forKey:@"RunnersEnd"];

        }
    }
    
    [self UpdateScoreBoard];
    
    //Add Batting order to the batsman
    int battingOrderCount=[[[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingOrderCount"] intValue];
    
    NSString *batTeam = [[self.MatchData objectForKey:currentInnings] objectForKey:@"BattingTeam"];
    if([[[[self.MatchData objectForKey:batTeam] objectForKey:newBatsman] objectForKey:@"BattingOrder"] intValue] == 13)
    {
        [[[self.MatchData objectForKey:batTeam] objectForKey:newBatsman] setObject:[NSNumber numberWithInt:battingOrderCount++] forKey:@"BattingOrder"];
        [[self.MatchData objectForKey:currentInnings] setObject:[NSNumber numberWithInt:battingOrderCount] forKey:@"BattingOrderCount"];
    }
    
    
    
    int Balls = [[[[self.MatchData objectForKey:currentInnings] objectForKey:@"Statistics"] objectForKey:@"Balls"] integerValue];
    float oversFloat = (Balls/6)+((Balls%6)/10.0f);
    if(oversFloat >= [[self.MatchData objectForKey:@"Overs"] floatValue])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self EndInnings:nil];
    }
    else if (fmod(Balls, 6.0) == 0.0 ) 
    {
        NSString *extraType = [outData objectForKey:@"ExtraType"];
        if([outData objectForKey:@"isFromExtras"] == NULL || ((NSString *)[outData objectForKey:@"isFromExtras"]).length == 0 || (extraType !=NULL && ([extraType isEqualToString:@"legbye"] || [extraType isEqualToString:@"bye"]) ))
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self ChangeBowler:nil];
            }];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void) AddAdditionalRuns:(int)addRuns andExtraType:(NSString *)extraType andIsOut:(BOOL)isOut andRunsFromBat:(BOOL)isRunsFromBat
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self AddExtra:extraType andRuns:addRuns andRunsFromBat:isRunsFromBat andIsOut:isOut];
        [self UpdateScoreBoard];
    }];
    
}

- (void) OutAction:(int)addRuns andOutType:(NSString *)outType andOutBatsman:(NSString *)outBatsman1 andOutBy:(NSString *)outByFielder andOnStrike:(NSString *)outOnStrikeBatsman andIsFromExtras:(BOOL)isFromExtras andExtraType:(NSString *)extraType
{
    NSString *currentInnings = [self.MatchData objectForKey:@"CurrentInnings"];
    NSMutableDictionary *outData = [NSMutableDictionary dictionaryWithCapacity:0];
    [outData setObject:[NSNumber numberWithInt:addRuns] forKey:@"addRuns"];
    [outData setObject:outType forKey:@"outType"];
    [outData setObject:outBatsman1 forKey:@"outBatsman"];
    [outData setObject:outByFielder forKey:@"outByFielder"];
    [outData setObject:outOnStrikeBatsman forKey:@"outOnStrikeBatsman"];
    [outData setObject:[[self.MatchData objectForKey:currentInnings] objectForKey:@"Bowler"] forKey:@"outByBowler"];
    if(isFromExtras)
    {
        [outData setObject:@"1" forKey:@"isFromExtras"];
        [outData setObject:extraType forKey:@"ExtraType"];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self ChangeBatsmanAfterOut:outData];
    }];
    
}

-(UIImage *)blurredBackgroundImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 3);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img stackBlur:60];
}

@end
