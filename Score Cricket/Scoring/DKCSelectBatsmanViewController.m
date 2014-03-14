//
//  DKCSelectBatsmanViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCSelectBatsmanViewController.h"

@interface DKCSelectBatsmanViewController ()

@end

@implementation DKCSelectBatsmanViewController
@synthesize batsmans;
@synthesize notOutbatsmans;
@synthesize doneButton;
@synthesize pickerView;
@synthesize selectedBatsman;
@synthesize onStrikeBatsman;
@synthesize runnersEndBatsman;
@synthesize delegate;
@synthesize changeBatsman;
@synthesize forBatsmanChange;
@synthesize cancelButton;
@synthesize outData;

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
    //[self.cancelButton addGradientWithCornerRadius:9];
    self.notOutbatsmans = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in self.batsmans) 
    {
        if (![key isEqualToString: @"TeamName"] && ![key isEqualToString: self.onStrikeBatsman] && ![key isEqualToString: self.runnersEndBatsman] ) 
        {
            NSString *outTypePlayer = [[[self.batsmans objectForKey:key] objectForKey:@"Batting"] objectForKey:@"OutType"];
            if ([outTypePlayer isEqualToString: @"DNB"] || [outTypePlayer isEqualToString: @"Not Out"] || [outTypePlayer isEqualToString: @"Retired" ]) 
            {
                NSMutableDictionary *tempPlayer = [self.batsmans objectForKey:key];
                [tempPlayer setObject:key forKey:@"ID"];
                [self.notOutbatsmans addObject:tempPlayer];
            }
        }
    }
    NSArray *sortedArray;
    sortedArray = [self.notOutbatsmans sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [(NSMutableDictionary*)a objectForKey:@"ID"];
        NSString *second = [(NSMutableDictionary*)b objectForKey:@"ID"];
        return [first compare:second];
    }];
    self.notOutbatsmans = [sortedArray mutableCopy];
    self.selectedBatsman = [[self.notOutbatsmans objectAtIndex:0] objectForKey:@"ID"];
    
    [self.pickerView reloadAllComponents];
    [self addMotionAffect];
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
    [self.cancelButton addMotionEffect:group];
    [self.pickerView addMotionEffect:group];
    [self.selectNextLabel addMotionEffect:group];
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
    return [self.notOutbatsmans count];
}

#pragma mark Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.notOutbatsmans objectAtIndex:row] objectForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectedBatsman = [[self.notOutbatsmans objectAtIndex:row] objectForKey:@"ID"];
}

-(IBAction)dismissSelf:(id)sender
{
    if(self.changeBatsman)
    {
        [self.delegate batsmanSelected:self.selectedBatsman andForBatsman:self.forBatsmanChange andOutType:@"Retired"];
    }
    else
    {
        [self.delegate batsmanSelectedAfterOut:self.selectedBatsman andForBatsman:self.forBatsmanChange andOutData:self.outData];
    }
}

-(IBAction)dismissSelfCancelPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
