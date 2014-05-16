//
//  DKCMainMenuViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCMainMenuViewController.h"
#import "DKCListOfMatchesViewController.h"
#import "DKCOnlineMatchesTableViewController.h"
#import "DKCCreatePList.h"
#import <QuartzCore/QuartzCore.h>
#import "DKCReachability.h"
#import "UIImage+StackBlur.h"
#import "DKCMatchesListCollectionViewController.h"
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

#import <Parse/Parse.h>

@interface DKCMainMenuViewController (){
    UIViewController *controllerToPush;
    UIView *animatedView;
}

@end

@implementation DKCMainMenuViewController
@synthesize BottomCurve;
@synthesize TopCurve;
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
	
    self.TopCurve.alpha=0.8;
    self.BottomCurve.alpha=0.9;
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
    
    self.backgroundImageView.image = [self.backgroundImageView.image stackBlur:60];
    [self addMotionAffect];
	
	
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
    self.TopCurve.frame=CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height/2) + 30);
    self.BottomCurve.frame=CGRectMake(0, (self.view.frame.size.height/2) - 30, self.view.frame.size.width, (self.view.frame.size.height/2) + 30);
    self.CreateMatch.alpha=0;
    self.CompletedMatches.alpha=0;
    self.InProgressMatch.alpha=0;
    
    self.Bat.transform=CGAffineTransformMakeRotation(M_PI_2/2+M_PI_2/10);
    
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.TopCurve.frame=CGRectMake(0, -((self.view.frame.size.height/2) + 15), self.view.frame.size.width, (self.view.frame.size.height/2) + 15);
                         self.BottomCurve.frame=CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 255);
                         self.CreateMatch.alpha=1;
                         self.CompletedMatches.alpha=1;
                         self.InProgressMatch.alpha=1;
                         
                     }
                     completion:nil];
    
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
	DKCOnlineMatchesTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DKCOnlineMatchesTableViewController"];
	controllerToPush = (UIViewController *)controller;
    [self pathAnimationForType:3];
}
-(IBAction)CompletedMatchesWithAnimation:(id)sender
{
	[self openOnlineMatches];
	return;
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

/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [animatedView.layer removeAnimationForKey:@"BallPath"];
    self.view.userInteractionEnabled = YES;
	[UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:controllerToPush animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


@end
