//
//  DKCCreateMatchViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCCreateMatchViewController.h"
#import "DKCCreatePList.h"
#import "UIImage+StackBlur.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "DKCBackgroundImage.h"
#import "UIImage+ImageEffects.h"

@interface DKCCreateMatchViewController ()
{
    NSInteger fieldActive;
    BOOL matchCreatedAndPushed;
}
@end

@implementation DKCCreateMatchViewController
@synthesize oversPerInnings;
@synthesize oversPerInningsValue;
@synthesize tossWon;
@synthesize tossWonValue;
@synthesize battingFirst;
@synthesize battingFirstValue;
@synthesize team1Button;
@synthesize team2Button;
@synthesize pickerView;
@synthesize StartScoring;
@synthesize oversPerInningsData;
@synthesize tossWonData;
@synthesize battingFirstData;
@synthesize team1Data;
@synthesize team2Data;
@synthesize team1Title;
@synthesize team2Title;

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
    self.screenName = @"Create Match";
    matchCreatedAndPushed = NO;
    
    [self.oversPerInnings makeRoundedCorner:9];
    [self.oversPerInningsValue makeRoundedCorner:9];
    [self.tossWon makeRoundedCorner:9];
    [self.tossWonValue makeRoundedCorner:9];
    [self.battingFirst makeRoundedCorner:9];
    [self.battingFirstValue makeRoundedCorner:9];
    [self.team1Button makeRoundedCorner:9];
    [self.team2Button makeRoundedCorner:9];
    
    [self.StartScoring makeRoundedCorner:9];
    
    
     self.pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-120.0 - self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 120.0)];
    self.pickerView.backgroundColor = [UIColor blackColor];
	self.pickerView.alpha = 0.8;
    self.pickerView.showsSelectionIndicator=YES;
    [self.view addSubview:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.team1Title=@"Team 1";
    self.team2Title=@"Team 2";
    
    [self.team1Button setTitle:self.team1Title forState:UIControlStateNormal];
    [self.team2Button setTitle:self.team2Title forState:UIControlStateNormal];
    
    self.oversPerInningsData = [[NSMutableArray alloc]initWithCapacity:100];
    for (int i=1; i<=100; i++) {
        [self.oversPerInningsData addObject:[[NSNumber alloc]initWithInt:i]];
    }
    
    self.tossWonData = [[NSMutableArray alloc] initWithObjects:self.team1Title,self.team2Title, nil];
    
    self.battingFirstData = self.tossWonData;
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.oversPerInningsValue setTitle:@"20" forState:UIControlStateNormal];
    [self.tossWonValue setTitle:self.team1Title forState:UIControlStateNormal];
    [self.battingFirstValue setTitle:self.team1Title forState:UIControlStateNormal];
    
    self.pickerView.alpha=0;
    
    self.oversPerInningsValue.titleLabel.textColor=[UIColor blackColor];
    self.battingFirstValue.titleLabel.textColor=[UIColor blackColor]; 
    self.tossWonValue.titleLabel.textColor=[UIColor blackColor];
    
    self.team1Data = [self MakeTeam:self.team1Title];
    self.team2Data = [self MakeTeam:self.team2Title];
    
    self.backgroundImageView.image = [DKCBackgroundImage backgroundImage];
    [self addMotionAffect];
}

- (void)addMotionAffect
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-15.0];
    xAxis.maximumRelativeValue = [NSNumber numberWithFloat:15.0];
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-15.0];
    yAxis.maximumRelativeValue = [NSNumber numberWithFloat:15.0];
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis,yAxis];
    [self.oversPerInnings addMotionEffect:group];
    [self.oversPerInningsValue addMotionEffect:group];
    [self.tossWon addMotionEffect:group];
    [self.tossWonValue addMotionEffect:group];
    [self.battingFirst addMotionEffect:group];
    [self.battingFirstValue addMotionEffect:group];
    [self.team1Button addMotionEffect:group];
    [self.team2Button addMotionEffect:group];
    [self.StartScoring addMotionEffect:group];
    [self.pickerView addMotionEffect:group];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(matchCreatedAndPushed)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void) refreshView
{
    self.navigationController.navigationBarHidden=NO;
    self.team1Title = [self.team1Data objectForKey:@"TeamName"];
    self.team2Title = [self.team2Data objectForKey:@"TeamName"];
    [self.team1Button setTitle:self.team1Title forState:UIControlStateNormal];
    [self.team2Button setTitle:self.team2Title forState:UIControlStateNormal];
    
    for (int i=0; i<2; i++) {
        if ([[self.tossWonData objectAtIndex:i] isEqualToString:self.tossWonValue.currentTitle]) {
            if (i==0) {
                [self.tossWonValue setTitle:self.team1Title forState:UIControlStateNormal];
                break;
            }
            else {
                [self.tossWonValue setTitle:self.team2Title forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    for (int i=0; i<2; i++) {
        if ([[self.battingFirstData objectAtIndex:i] isEqualToString:self.battingFirstValue.currentTitle]) {
            if (i==0) {
                [self.battingFirstValue setTitle:self.team1Title forState:UIControlStateNormal];
                break;
            }
            else {
                [self.battingFirstValue setTitle:self.team2Title forState:UIControlStateNormal];
                break;
            }
        }
    }
    self.battingFirstValue.titleLabel.textColor=[UIColor blackColor]; 
    self.tossWonValue.titleLabel.textColor=[UIColor blackColor];
    
    [self.tossWonData replaceObjectAtIndex:0 withObject:self.team1Title];
    [self.tossWonData replaceObjectAtIndex:1 withObject:self.team2Title];
    
    self.battingFirstData = self.tossWonData;
    
    [self.pickerView reloadAllComponents];
}

- (void) dismissEditTeam
{
    [self refreshView];
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

#pragma mark -
#pragma mark Picker Data Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (fieldActive==1) {
        return [self.oversPerInningsData count];
    }
    else if (fieldActive==2)
    {
        return [self.tossWonData count];
    }
    else if (fieldActive==3)
    {
        return [self.battingFirstData count];
    }
    return 1;
}

#pragma mark Picker Delegate Methods

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
	if (fieldActive==1) {
        title = [[self.oversPerInningsData objectAtIndex:row] stringValue];
    }
    else if (fieldActive==2)
    {
        title = [self.tossWonData objectAtIndex:row];
    }
    else if (fieldActive==3)
    {
        title = [self.battingFirstData objectAtIndex:row];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	return attString;
	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (fieldActive==1) 
    {
        [self.oversPerInningsValue setTitle:[[self.oversPerInningsData objectAtIndex:row] stringValue] forState:UIControlStateNormal];
    }
    else if (fieldActive==2)
    {
        [self.tossWonValue setTitle:[self.tossWonData objectAtIndex:row] forState:UIControlStateNormal];
    }
    else if (fieldActive==3)
    {
        [self.battingFirstValue setTitle:[self.battingFirstData objectAtIndex:row] forState:UIControlStateNormal];
    }
    
}

-(IBAction)OversPerInningsAction:(id)sender
{
    self.pickerView.alpha=1;
    self.oversPerInningsValue.backgroundColor=[UIColor blueColor];
    self.oversPerInningsValue.titleLabel.textColor=[UIColor whiteColor];
    self.battingFirstValue.backgroundColor=[UIColor whiteColor];
    self.battingFirstValue.titleLabel.textColor=[UIColor blackColor]; 
    self.tossWonValue.backgroundColor=[UIColor whiteColor];
    self.tossWonValue.titleLabel.textColor=[UIColor blackColor];
    fieldActive=1;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:[self.oversPerInningsValue.currentTitle intValue]-1 inComponent:0 animated:YES];
}
-(IBAction)TossWonAction:(id)sender
{
    self.pickerView.alpha=1;
    self.oversPerInningsValue.backgroundColor=[UIColor whiteColor];
    self.oversPerInningsValue.titleLabel.textColor=[UIColor blackColor];
    self.battingFirstValue.backgroundColor=[UIColor whiteColor];
    self.battingFirstValue.titleLabel.textColor=[UIColor blackColor]; 
    self.tossWonValue.backgroundColor=[UIColor blueColor];
    self.tossWonValue.titleLabel.textColor=[UIColor whiteColor];
    fieldActive=2;
    [self.pickerView reloadAllComponents];
    int i=0;
    for (i=0; i<2; i++) {
        if ([[self.tossWonData objectAtIndex:i] isEqualToString:self.tossWonValue.currentTitle]) {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:0 animated:YES];
}
-(IBAction)BattingFirstAction:(id)sender
{
    self.pickerView.alpha=1;
    self.oversPerInningsValue.backgroundColor=[UIColor whiteColor];
    self.oversPerInningsValue.titleLabel.textColor=[UIColor blackColor];
    self.battingFirstValue.backgroundColor=[UIColor blueColor];
    self.battingFirstValue.titleLabel.textColor=[UIColor whiteColor]; 
    self.tossWonValue.backgroundColor=[UIColor whiteColor];
    self.tossWonValue.titleLabel.textColor=[UIColor blackColor];
    fieldActive=3;
    [self.pickerView reloadAllComponents];
    int i=0;
    for (i=0; i<2; i++) {
        if ([[self.battingFirstData objectAtIndex:i] isEqualToString:self.battingFirstValue.currentTitle]) {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:0 animated:YES];
    
}
-(IBAction)StartScoringAction:(id)sender
{
    DKCScoringViewController *score = [self.storyboard instantiateViewControllerWithIdentifier:@"Scoring"];
    NSMutableDictionary *tempDict;
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *fileName = [formatter stringFromDate:now];
    tempDict = [self MakeMatch];
    [tempDict setObject:fileName forKey:@"FileName"];
    [DKCCreatePList CreatePlistDictionaryWithName:fileName withData:tempDict];
    
    //Add match to ListOfMatches
    [DKCCreatePList AddObjectToMatchesListWithFileName:fileName andTeam1:[[tempDict objectForKey:@"Team1"] objectForKey:@"TeamName"] andTeam2:[[tempDict objectForKey:@"Team2"] objectForKey:@"TeamName"]];
	
	[DKCCreatePList CreateParseObjectWithFileName:fileName matchData:tempDict status:@"current"];
    
    NSLog(@"%@",[[tempDict objectForKey:@"Team1"] objectForKey:@"TeamName"]);
    
    score.MatchData=tempDict;
    
    matchCreatedAndPushed = YES;
    self.title = @"Back";
    
    [self.navigationController pushViewController:score animated:YES];
    
}

-(IBAction)EditTeam1:(id)sender
{
    [self presentEditTeamWithTableData:self.team1Data];
}
-(IBAction)EditTeam2:(id)sender
{
    [self presentEditTeamWithTableData:self.team2Data];

}

- (void)presentEditTeamWithTableData:(NSMutableDictionary *)teamTableData
{
    DKCEditTeamViewController *editTeam = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTeam"];
    editTeam.delegate=self;
    editTeam.tableData = teamTableData;
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 3);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	editTeam.backgroundBlurredImage = [DKCBackgroundImage backgroundImageWithImage:img];
    
    UINavigationController *tempNavController = [[UINavigationController alloc] initWithRootViewController:editTeam];
    tempNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    tempNavController.navigationItem.rightBarButtonItem = UIBarButtonSystemItemDone;
    [self presentModalViewController:tempNavController animated:YES];
}

-(NSMutableDictionary *)MakeBattingObject
{
    NSMutableDictionary *battingTemp = [[NSMutableDictionary alloc] initWithCapacity:11];
    
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Score"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Balls"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"0"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"1"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"2"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"3"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"4"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"5"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"6"];
    [battingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"7"];
    
    NSMutableArray *tempBallbyBall = [[NSMutableArray alloc] initWithCapacity:0];
    [battingTemp setObject:tempBallbyBall forKey:@"BallbyBall"];
    [battingTemp setObject:@"DNB" forKey:@"OutType"];
    [battingTemp setObject:@"None" forKey:@"OutByFielder"];
    [battingTemp setObject:@"None" forKey:@"OutByBowler"];
    
    return battingTemp;
}

-(NSMutableDictionary *)MakeBowlingObject
{
    NSMutableDictionary *bowlingTemp = [[NSMutableDictionary alloc] initWithCapacity:12];
    
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Runs"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Balls"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Wides"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"NoBalls"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Byes"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"LegByes"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Extras"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Wickets"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Lbws"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Catches"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Bolds"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"0"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"1"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"2"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"3"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"4"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"5"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"6"];
    [bowlingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"7"];
    
    NSMutableArray *tempBallbyBall = [[NSMutableArray alloc] initWithCapacity:0];
    [bowlingTemp setObject:tempBallbyBall forKey:@"BallbyBall"];
    
    return bowlingTemp;
}

-(NSMutableDictionary *)MakeFieldingObject
{
    NSMutableDictionary *fieldingTemp = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [fieldingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Catches"];
    [fieldingTemp setObject:[[NSNumber alloc] initWithInt:0] forKey:@"RunOuts"];
    
    return fieldingTemp;
}

-(NSMutableDictionary *)MakePlayer:(NSString *) Name
{
    NSMutableDictionary *playerTemp = [[NSMutableDictionary alloc] initWithCapacity:4];
    [playerTemp setObject:[self MakeBattingObject] forKey:@"Batting"];
    [playerTemp setObject:[self MakeBowlingObject] forKey:@"Bowling"];
    [playerTemp setObject:[self MakeFieldingObject] forKey:@"Fielding"];
    [playerTemp setObject:[NSNumber numberWithInt:13] forKey:@"BattingOrder"];
    [playerTemp setObject:[NSNumber numberWithInt:13] forKey:@"BowlingOrder"];
    [playerTemp setObject:Name forKey:@"Name"];
    
    
    return playerTemp;
}

-(NSMutableDictionary *)MakeTeam:(NSString *)TeamName
{
    NSMutableDictionary *teamTemp = [[NSMutableDictionary alloc] initWithCapacity:12];
    for(int i=1;i<12;i++)
    {
        NSString *tempPlayerName = [@"Player" stringByAppendingString:[[[NSNumber alloc] initWithInt:i] stringValue]];
        
        [teamTemp setObject:[self MakePlayer:tempPlayerName] forKey:[@"P" stringByAppendingString:[[[NSNumber alloc] initWithInt:i] stringValue]]];
    }
    [teamTemp setObject:TeamName forKey:@"TeamName"];
    
    return teamTemp;
}

-(NSMutableDictionary *)MakeStatisticsObject
{
    NSMutableDictionary *tempStats = [[NSMutableDictionary  alloc] initWithCapacity:18];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"0"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"1"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"2"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"3"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"4"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"5"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"6"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"7"];
    
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Score"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Balls"];
    
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Extras"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Wides"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"NoBalls"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Byes"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"LegByes"];
    
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Wickets"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Lbws"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Catches"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"Bolds"];
    [tempStats setObject:[[NSNumber alloc] initWithInt:0] forKey:@"RunOuts"];
    
    return tempStats;
}

-(NSMutableDictionary *)MakeOversObject:(int)overs
{
    NSMutableDictionary *tempOvers = [[NSMutableDictionary alloc] initWithCapacity:overs];
    for (int i=1; i<=overs; i++) {
        [tempOvers setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    return tempOvers;
}

-(NSMutableArray *)MakeBattingOrderObject
{
    NSMutableArray *tempOrder= [[NSMutableArray alloc] initWithCapacity:11];
    return tempOrder;
}

-(NSMutableArray *)MakeBowlingOrderObject
{
    NSMutableArray *tempOrder= [[NSMutableArray alloc] initWithCapacity:11];
    return tempOrder;
}

-(NSMutableDictionary *)MakeInnings:(int)inningNumber andOvers:(int)overs andBattingTeam:(NSString *)battingTeam andBowlingTeam:(NSString *) bowlingTeam andOnStrike:(NSString *)onStrike andRunnersEnd:(NSString *)runnersEnd andbowler:(NSString *)bowler
{
    NSMutableDictionary *tempInnings = [[NSMutableDictionary alloc]initWithCapacity:9];
    
    [tempInnings setObject:[self MakeStatisticsObject] forKey:@"Statistics"];
    [tempInnings setObject:[self MakeOversObject:overs] forKey:@"Overs"];
    [tempInnings setObject:battingTeam forKey:@"BattingTeam"];
    [tempInnings setObject:bowlingTeam forKey:@"BowlingTeam"];
    [tempInnings setObject:[self MakeBattingOrderObject] forKey:@"BattingOrder"];
    [tempInnings setObject:[self MakeBowlingOrderObject] forKey:@"BowlingOrder"];
    [tempInnings setObject:onStrike forKey:@"OnStrike"];
    [tempInnings setObject:runnersEnd forKey:@"RunnersEnd"];
    [tempInnings setObject:onStrike forKey:@"LastBallOnStrike"];
    [tempInnings setObject:bowler forKey:@"Bowler"];
    [tempInnings setObject:bowler forKey:@"LastBallBowler"];
    [tempInnings setObject:[NSNumber numberWithInt:0] forKey:@"BattingOrderCount"];
    [tempInnings setObject:[NSNumber numberWithInt:0] forKey:@"BowlingOrderCount"];
    
    return tempInnings;
}

-(NSMutableDictionary *)MakeMatch
{
    NSMutableDictionary *tempMatch = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    NSString *batting;
    NSString *bowling;
    if([self.battingFirstValue.currentTitle isEqualToString:[self.team1Data objectForKey:@"TeamName"]])
    {
        batting = @"Team1";
        bowling = @"Team2";
    }
    else 
    {
        batting = @"Team2";
        bowling = @"Team1";
    }
    
    [tempMatch setObject:[self MakeInnings:1 andOvers:[self.oversPerInningsValue.currentTitle intValue] andBattingTeam:batting andBowlingTeam:bowling andOnStrike:@"P1" andRunnersEnd:@"P2" andbowler:@"P11"] forKey:@"FirstInnings"];
    
    [tempMatch setObject:[self MakeInnings:2 andOvers:[self.oversPerInningsValue.currentTitle intValue] andBattingTeam:bowling andBowlingTeam:batting andOnStrike:@"P1" andRunnersEnd:@"P2" andbowler:@"P11"] forKey:@"SecondInnings"];
    
    [tempMatch setObject:self.team1Data forKey:@"Team1"];
    [tempMatch setObject:self.team2Data forKey:@"Team2"];
    [tempMatch setObject:[NSNumber numberWithInt:0] forKey:@"Status"];
    [tempMatch setObject:@"FirstInnings" forKey:@"CurrentInnings"];
    [tempMatch setObject:[NSNumber numberWithInt:[self.oversPerInningsValue.currentTitle intValue]] forKey:@"Overs"];
    
    return tempMatch;
    
}




@end
