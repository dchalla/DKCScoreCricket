//
//  DKCMainMenuViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCMainMenuViewController.h"
#import "DKCListOfMatchesViewController.h"
#import "DKCOnlineMatchesViewController.h"
#import "DKCCreatePList.h"
#import <QuartzCore/QuartzCore.h>
#import "DKCReachability.h"
#import "UIImage+StackBlur.h"
#import "DKCMatchesListCollectionViewController.h"
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

#import <Parse/Parse.h>
#import "DKCBackgroundImage.h"
#import "DKCScoreTableViewCell.h"
#import "AMBlurView.h"

@interface DKCMainMenuViewController (){
    UIViewController *controllerToPush;
    UIView *animatedView;
	NSIndexPath *_cellIndexPath;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DKCMainMenuViewController
@synthesize CreateMatch;
@synthesize InProgressMatch;
@synthesize CompletedMatches;
@synthesize Bat;
@synthesize CreateMatchLabel;
@synthesize CompletedMatchesLabel;
@synthesize EditMatchLabel;

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
	self.screenName = @"Main Menu Screen";
	self.backgroundImageView.image = [DKCBackgroundImage backgroundImage];
	
    [self.CompletedMatches makeRoundedCorner:35];
    [self.CreateMatch makeRoundedCorner:35];
    [self.InProgressMatch makeRoundedCorner:35];
    
    [self.CompletedMatchesLabel makeRoundedCorner:12];
    [self.CreateMatchLabel makeRoundedCorner:12];
    [self.EditMatchLabel makeRoundedCorner:12];
    
    UITapGestureRecognizer *createMatchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CreateMatchWithAnimation:)];
    self.CreateMatchLabel.gestureRecognizers = [NSArray arrayWithObject:createMatchGesture];
    
    UITapGestureRecognizer *inProgressMatchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InProgressMatchesWithAnimation:)];
    self.EditMatchLabel.gestureRecognizers = [NSArray arrayWithObject:inProgressMatchesGesture];
    
    UITapGestureRecognizer *completedMatchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CompletedMatchesWithAnimation:)];
    self.CompletedMatchesLabel.gestureRecognizers = [NSArray arrayWithObject:completedMatchesGesture];
	// Do any additional setup after loading the view.
	
	[self addMotionAffect];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 280, self.view.bounds.size.width + 120, self.view.frame.size.height)];
	[self.view addSubview:self.tableView];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.transform = CGAffineTransformMakeRotation(-M_PI * 15/180);
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.CreateMatch.alpha=0;
    self.CompletedMatches.alpha=0;
    self.InProgressMatch.alpha=0;
	self.CreateMatchLabel.alpha = 0;
	self.EditMatchLabel.alpha = 0;
	self.CompletedMatchesLabel.alpha = 0;
	self.tableView.alpha = 0;
	self.backgroundImageView.alpha = 0;
	self.backgroundInitialImageView.image = self.backgroundInitialImage;
}

- (void)addMotionAffect
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
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
    [self.CreateMatch addMotionEffect:group];
    [self.CreateMatchLabel addMotionEffect:group];
    [self.InProgressMatch addMotionEffect:group];
    [self.EditMatchLabel addMotionEffect:group];
    [self.CompletedMatches addMotionEffect:group];
    [self.CompletedMatchesLabel addMotionEffect:group];
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
    
    self.Bat.transform=CGAffineTransformMakeRotation(M_PI_2/2+M_PI_2/10);
    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[UIView animateWithDuration:0.6 animations:^{
		self.CreateMatch.alpha=1;
		self.CompletedMatches.alpha=1;
		self.CreateMatchLabel.alpha = 1;
		self.EditMatchLabel.alpha = 1;
		self.CompletedMatchesLabel.alpha = 1;
		self.InProgressMatch.alpha=1;
		self.tableView.alpha = 1;
		self.backgroundImageView.alpha = 1;
	}];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)CreateMatchWithAnimation:(id)sender
{
    DKCCreateMatchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMatchViewController"];
    controllerToPush = (UIViewController *)controller;
    [self pathAnimationForType:1];
}
-(IBAction)InProgressMatchesWithAnimation:(id)sender
{
    DKCMatchesListCollectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DKCMatchesListCollectionViewController"];
    controller.isCompleted = NO;
    controllerToPush = (UIViewController *)controller;
    [self pathAnimationForType:2];
}

- (void)openOnlineMatches
{
	DKCOnlineMatchesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DKCOnlineMatchesViewController"];
	if (_cellIndexPath.row == 0)
	{
		controller.isLive = YES;
	}
	else
	{
		controller.isLive = NO;
	}
	[self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)CompletedMatchesWithAnimation:(id)sender
{
    DKCMatchesListCollectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DKCMatchesListCollectionViewController"];
    controller.isCompleted = YES;
    controllerToPush = (UIViewController *)controller;
    [self pathAnimationForType:3];
}


- (void)pathAnimationForType:(int)type
{
    self.view.userInteractionEnabled = NO;
    CGMutablePathRef path = CGPathCreateMutable();
    UIView *tempView;
    if (type==1) {
        tempView = self.CreateMatch;
        CGPathMoveToPoint(path,NULL,tempView.center.x,tempView.center.y);
        
        CGPathAddCurveToPoint(path,NULL,tempView.center.x,tempView.center.y - 100.0,
                              tempView.center.x+150,tempView.center.y - 100.0,
                              tempView.center.x + 250.0,tempView.center.y + 500.0);
    }
    else if(type==2) {
        tempView = self.InProgressMatch;
        CGPathMoveToPoint(path,NULL,tempView.center.x,tempView.center.y);
        
        CGPathAddCurveToPoint(path,NULL,tempView.center.x,tempView.center.y - 100.0,
                              tempView.center.x+100,tempView.center.y - 100.0,
                              tempView.center.x + 250.0,tempView.center.y + 500.0);
    }
    else {
        tempView = self.CompletedMatches;
        CGPathMoveToPoint(path,NULL,tempView.center.x,tempView.center.y);
        
        CGPathAddCurveToPoint(path,NULL,tempView.center.x,tempView.center.y - 100.0,
                              tempView.center.x-150,tempView.center.y - 100.0,
                              tempView.center.x - 250.0,tempView.center.y + self.view.frame.size.height);
    }
    
    
    CAKeyframeAnimation *
    animation = [CAKeyframeAnimation
                 animationWithKeyPath:@"position"];
    
    [animation setPath:path];
    [animation setDuration:0.6];
    
    
    CFRelease(path);
    
    // Create a basic animation to restore the size of the placard.
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.duration = 0.6;
	transformAnimation.toValue = [NSNumber numberWithDouble:0.3];
	
	
	// Create an animation group to combine the keyframe and basic animations.
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction.
	theGroup.delegate = self;
	theGroup.duration = 0.6;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    theGroup.fillMode = kCAFillModeForwards;
    theGroup.removedOnCompletion = NO;
	
	theGroup.animations = @[animation, transformAnimation];
    animatedView = tempView;
    [tempView.layer addAnimation:theGroup forKey:@"BallPath"];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
	backgroundView.backgroundColor = [UIColor clearColor];
	UIView *blurView = [UIView new];
	blurView.frame = CGRectMake(0, 0, tableView.frame.size.width, 25);
	blurView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, blurView.frame.size.width - 2*60, blurView.frame.size.height)];
	[blurView addSubview:label];
	label.textColor = [UIColor colorWithWhite:0.7 alpha:1];
	label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
	if (section == 0)
	{
		label.text = @"Follow matches around the world";
	}
	else
	{
		label.text = @"Score a match";
	}
	
	[backgroundView addSubview:blurView];
	return backgroundView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor clearColor];
	
	UIView *blurView = [UIView new];
	blurView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	blurView.frame = CGRectMake(0, 0, tableView.frame.size.width, 400);
	[backgroundView addSubview:blurView];
	return backgroundView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (section == 0)
	{
		return 2;
	}
	else
	{
		return 3;
	}
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] init];
		cell.clipsToBounds = YES;
		cell.backgroundColor = [UIColor clearColor];
		cell.contentView.backgroundColor = [UIColor clearColor];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.frame = CGRectMake(80, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width - 2*60, cell.textLabel.frame.size.height);
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UIView *blurView = [UIView new];
		blurView.frame = cell.frame;
		blurView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[cell insertSubview:blurView belowSubview:cell.backgroundView];
	}
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, cell.frame.size.width - 2*60, cell.frame.size.height)];
	[cell addSubview:label];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
	if (indexPath.row == 0)
	{
		label.text = @"Live Scores";
	}
	else if (indexPath.row == 1)
	{
		label.text = @"Results";
	}
    
	
    return cell;
}

#pragma mark - Table view delegate
#define delay 0.1
#define animationDuration 1
#define animationAmplitude 5


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.width != self.view.frame.size.width)
    {
        //return;
    }
    _cellIndexPath = indexPath;
    [self bounceView:cell amplitude:animationAmplitude duration:animationDuration delegate:YES];
    for (int i =1; i<=4; i++)
    {
        if (indexPath.row - i >= 0)
        {
            UITableViewCell *tempCell = (UITableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - i inSection:0]];
            if (tempCell)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * (i + 1) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    CGFloat modifier = 1 / (1.f * i + 1);
                    modifier = powf(modifier, i);
                    CGFloat subAmplitude = animationAmplitude * modifier;
                    [self bounceView:tempCell amplitude:subAmplitude duration:animationDuration delegate:NO];
                });
            }
        }
	}
    
}

#define DEGREES(rads) rads * M_PI / 180.f
- (void)bounceView:(UIView *)view amplitude:(CGFloat)amplitude duration:(CGFloat)duration delegate:(BOOL)getDelegateCall {
    CGRect tempFrame = view.frame;
    tempFrame.size.width = (self.view.frame.size.width + 120) * 2;
    view.frame = tempFrame;
    CGFloat m34 = 1 / 50.f* (view.layer.anchorPoint.x == 0 ? -1 : 1);
    CGFloat bounceAngleModifiers[] = {1, 0.33f, 0.13f};
    NSInteger bouncesCount = sizeof(bounceAngleModifiers) / sizeof(CGFloat);
    bouncesCount = bouncesCount * 2 + 1;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    view.layer.transform = transform;
    
    CAKeyframeAnimation *bounceKeyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];
    bounceKeyframe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceKeyframe.duration = duration;
    
    NSMutableArray *bounceValues = [NSMutableArray array];
    for (NSInteger i = 0; i < bouncesCount; i++) {
        CGFloat angle = 0;
        if (i % 2 > 0) {
            angle = bounceAngleModifiers[i / 2] * amplitude;
        }
        [bounceValues addObject:@(DEGREES(angle))];
    }
    bounceKeyframe.values = bounceValues;
    if (getDelegateCall)
    {
        bounceKeyframe.delegate = self;
    }
    
    [view.layer setValue:@(0) forKeyPath:bounceKeyframe.keyPath];
    [view.layer addAnimation:bounceKeyframe forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if ([anim isKindOfClass:[CAKeyframeAnimation class]])
	{
		UITableViewCell *cell = (UITableViewCell *) [self.tableView cellForRowAtIndexPath:_cellIndexPath];
		CGRect tempFrame = cell.frame;
		tempFrame.size.width = (self.view.frame.size.width + 120);
		cell.frame = tempFrame;
		[self openOnlineMatches];
	}
	else
	{
		[animatedView.layer removeAnimationForKey:@"BallPath"];
		self.view.userInteractionEnabled = YES;
		
		[self.navigationController pushViewController:controllerToPush animated:YES];
		
	}
}
 



@end
