//
//  DKCViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DKCViewController ()

@end

@implementation DKCViewController
@synthesize backgroundImageView;
@synthesize Title;
@synthesize BallImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.backgroundImageView.alpha=0.5;
    self.Title.alpha=0;
    self.BallImageView.alpha=0;
    [self.BallImageView makeRoundedCorner:7.5];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    self.backgroundImageView.alpha=0.5;
    self.Title.alpha=0;
    
    CGRect ballPosition2;
    CGRect ballposition3;
    CGRect ballposition4;
    if (self.view.frame.size.height <= 480)
    {
        ballPosition2 = CGRectMake(139, 179, 15, 15);
        ballposition3= CGRectMake(147, 206, 15, 15);
        ballposition4= CGRectMake(147, 206, 305, 305);
    }
    else
    {
        ballPosition2 = CGRectMake(139, 206, 15, 15);
        ballposition3= CGRectMake(147, 246, 15, 15);
        ballposition4= CGRectMake(147, 246, 305, 305);
    }
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         //self.backgroundImageView.alpha=1;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0 animations:^{
                             //self.Title.alpha=1;
                             //self.BallImageView.alpha=1;
                             
                         }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.6
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionOverrideInheritedCurve |
                                               UIViewAnimationOptionCurveLinear |
                                               UIViewAnimationOptionOverrideInheritedDuration
                                                               animations:^{
                                                                   self.backgroundImageView.alpha=1;
                                                                   self.Title.alpha=1;
                                                                   self.BallImageView.alpha=1;
                                                                   BallImageView.frame = ballPosition2;
                                                                   
                                                                   [UIView animateWithDuration:0.4
                                                                                         delay:0.0
                                                                                       options:UIViewAnimationOptionOverrideInheritedCurve |
                                                                    UIViewAnimationOptionCurveLinear |
                                                                    UIViewAnimationOptionOverrideInheritedDuration
                                                                                    animations:^{
                                                                                        BallImageView.frame = ballposition3;
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.3
                                                                                                              delay:0.0
                                                                                                            options:UIViewAnimationOptionOverrideInheritedCurve |
                                                                                         UIViewAnimationOptionCurveLinear |
                                                                                         UIViewAnimationOptionOverrideInheritedDuration animations:^{
                                                                                             [self.BallImageView makeRoundedCorner:153];
                                                                                             BallImageView.frame = ballposition4;
                                                                                             
                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             DKCMainMenuViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
                                                                                                             [UIView  beginAnimations:nil context:NULL];
                                                                                                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                                                                             [UIView setAnimationDuration:0.75];
                                                                                                             [self.navigationController pushViewController:mainMenu animated:NO];
                                                                                                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                                                                                                             [UIView commitAnimations];
                                                                                                             self.BallImageView.alpha=0.0;
                                                                                                             self.BallImageView.frame=CGRectMake(228, 68, 15, 15);
                                                                                                             [self.BallImageView makeRoundedCorner:7.5];
                                                                                                             
                                                                                                             
                                                                                                             
                                                                                                         } ];
                                                                                    }];
                                                                   
                                                               }
                                                               completion:^(BOOL finished) {
                                                               }];
                                              
                                          }];
                         
                     }];
    
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

@end
