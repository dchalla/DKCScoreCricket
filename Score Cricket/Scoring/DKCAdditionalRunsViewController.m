//
//  DKCAdditionalRunsViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCAdditionalRunsViewController.h"

@interface DKCAdditionalRunsViewController ()

@end

@implementation DKCAdditionalRunsViewController
@synthesize doneButton;
@synthesize outLabel;
@synthesize outOrNotSegment;
@synthesize pickerView;
@synthesize ExtraType;
@synthesize runsArray;
@synthesize runsSelected;
@synthesize delegate;
@synthesize runsFromBatLabel;
@synthesize runsFromBatSegment;

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
    int capacity=5;
    int i=1;
    self.runsSelected=[NSNumber numberWithInt:1];
    self.runsFromBatSegment.enabled= NO;
    if ([self.ExtraType isEqualToString:@"noball"]) 
    {
        capacity=7;
        i=0;
        self.runsSelected = [NSNumber numberWithInt:0];
        self.runsFromBatSegment.selectedSegmentIndex = 1;
        self.runsFromBatSegment.enabled = YES;
    }
    else if ([self.ExtraType isEqualToString:@"wide"])
    {
        capacity = 6;
        i=0;
        self.runsSelected = [NSNumber numberWithInt:0];
    }
    self.runsArray = [NSMutableArray arrayWithCapacity:capacity];
    for (; i<capacity; i++) 
    {
        [self.runsArray addObject:[NSNumber numberWithInt:i]];
    }
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView reloadAllComponents];
    //[self.doneButton addGradientWithCornerRadius:9];
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
    [self.outOrNotSegment addMotionEffect:group];
    [self.outLabel addMotionEffect:group];
    [self.runsFromBatSegment addMotionEffect:group];
    [self.runsFromBatLabel addMotionEffect:group];
    [self.additionalRunsLabel addMotionEffect:group];
}

- (void)viewWillDisappear:(BOOL)animated
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
    return [self.runsArray count];
}

#pragma mark Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[runsArray objectAtIndex:row] stringValue];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.runsSelected = [runsArray objectAtIndex:row];
}

-(IBAction)dismissSelf:(id)sender
{
    int selectedIndex=[self.outOrNotSegment selectedSegmentIndex];
    
    [[self delegate] AddAdditionalRuns:[self.runsSelected intValue] andExtraType:self.ExtraType andIsOut:selectedIndex==1 andRunsFromBat:(self.runsFromBatSegment.selectedSegmentIndex == 1)];
}

@end
