//
//  DKCSelectBowlerViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCSelectBowlerViewController.h"

@interface DKCSelectBowlerViewController ()

@end

@implementation DKCSelectBowlerViewController
@synthesize bowlers;
@synthesize pickerView;
@synthesize selectedBowler;
@synthesize doneButton;
@synthesize delegate;
@synthesize currentBowler;
@synthesize hardStop;

-(void)setBackgroundBlurImage:(UIImage *)backgroundBlurImage
{
    _backgroundBlurImage = backgroundBlurImage;
    self.backgroundImageView.image = backgroundBlurImage;
}

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
    //[self.doneButton addGradientWithCornerRadius:9];
    self.selectedBowler = self.currentBowler;
    [self addMotionAffect];
	self.backgroundImageView.image = _backgroundBlurImage;
}

- (void)addMotionAffect
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-20.0];
    xAxis.maximumRelativeValue = [NSNumber numberWithFloat:20.0];
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-20.0];
    yAxis.maximumRelativeValue = [NSNumber numberWithFloat:20.0];
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis,yAxis];
    [self.doneButton addMotionEffect:group];
    [self.pickerView addMotionEffect:group];
    [self.selectNextLabel addMotionEffect:group];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int row = [[self.currentBowler substringFromIndex:1] integerValue]-1;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
    
    NSString *player = [NSString stringWithFormat:@"P%d",row+1];
    if (!([self.currentBowler isEqualToString:player]&&self.hardStop)) 
    {
        self.selectedBowler = player;
    }
    else 
    {
        if (row == 10) 
        {
            row --;
        }
        else 
        {
            row ++;
        }
        player = [NSString stringWithFormat:@"P%d",row+1];
        self.selectedBowler = player;
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    return 11;
}

#pragma mark Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.bowlers objectForKey: [NSString stringWithFormat:@"P%d",row+1]]objectForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *player = [NSString stringWithFormat:@"P%d",row+1];
    if (!([self.currentBowler isEqualToString:player]&&self.hardStop)) 
    {
        self.selectedBowler = player;
    }
    else 
    {
        if (row == 10) 
        {
            row --;
        }
        else 
        {
            row ++;
        }
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }
}

-(IBAction)dismissSelf:(id)sender
{
    
    if (!([self.currentBowler isEqualToString:self.selectedBowler]&&self.hardStop)) 
    {
        [[self delegate] bowlerSelected:self.selectedBowler];
    }
}


@end
