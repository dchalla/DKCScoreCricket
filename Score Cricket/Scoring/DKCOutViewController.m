//
//  DKCOutViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCOutViewController.h"

@interface DKCOutViewController ()

@end

@implementation DKCOutViewController
@synthesize doneButton;
@synthesize who;
@synthesize how;
@synthesize by;
@synthesize pickerView1;
@synthesize runs;
@synthesize stepper;
@synthesize onStrike;
@synthesize bowler;
@synthesize runnersEnd;
@synthesize delegate;
@synthesize segmentCtl;
@synthesize selectedBy;
@synthesize selectedWho;
@synthesize selectedHow;
@synthesize runsValue;
@synthesize isFromExtras;
@synthesize extraType;

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
    [self.runs makeRoundedCorner:9];
    //[self.doneButton addGradientWithCornerRadius:9];
    
    self.how = [NSMutableArray arrayWithCapacity:0];
    [self.how addObject:@"Bowled"];
    [self.how addObject:@"Timed Out"];
    [self.how addObject:@"Caught"];
    [self.how addObject:@"Handled Ball"];
    [self.how addObject:@"Hit Ball Twice"];
    [self.how addObject:@"Hit Wicket"];
    [self.how addObject:@"LBW"];
    [self.how addObject:@"Obstructing Field"];
    [self.how addObject:@"Run Out"];
    [self.how addObject:@"Stumped"];
    
    fixLineBreakMode(self.segmentCtl);
    
    [self.segmentCtl setTitle:[[self.who  objectForKey:self.runnersEnd] objectForKey:@"Name"] forSegmentAtIndex:0];
    [self.segmentCtl setTitle:@"New Batsman" forSegmentAtIndex:1];
    [self.segmentCtl setSelectedSegmentIndex:1];
    
    self.selectedHow = @"Bowled";
    self.selectedWho = self.onStrike;
    self.selectedBy = @"NA";
    
    [self.segmentCtl addTarget:self
                         action:@selector(BatsmanOnStrikeSelected:)
               forControlEvents:UIControlEventValueChanged];
    [self.stepper setEnabled:NO];
    
    
    if(isFromExtras)
    {
        [self.pickerView1 selectRow:8 inComponent:0 animated:YES];
        self.selectedHow = @"Run Out";
    }
    else 
    {
        extraType = @"";
    }
    
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
    [self.pickerView1 addMotionEffect:group];
    [self.runs addMotionEffect:group];
    [self.stepper addMotionEffect:group];
    [self.segmentCtl addMotionEffect:group];
    [self.onStrikeLabel addMotionEffect:group];
    [self.howWhoByLabel addMotionEffect:group];
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

static void fixLineBreakMode(UIView *view)
{
    if ([view respondsToSelector:@selector(setLineBreakMode:)]) {
        [(id)view setLineBreakMode:UILineBreakModeTailTruncation];
        [view setFrame:CGRectInset([view.superview bounds], 6, 0)];
    } else {
        for (UIView *subview in view.subviews)
            fixLineBreakMode(subview);
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) 
    {
        return [self.how count];
    }
    else if (component==2) 
    {
        return 11;
    }else 
    {
        return 2;
    }
    return 1;
}

#pragma mark Picker Delegate Methods
//- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component==0) {
//        return [self.how objectAtIndex:row];
//    }
//    return @"1";
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) 
    {
        self.selectedHow = [self.how objectAtIndex:row];
        if([selectedHow isEqualToString: @"Bowled"] || [selectedHow isEqualToString: @"Handled Ball"] || [selectedHow isEqualToString: @"Hit Ball Twice"] || [selectedHow isEqualToString: @"Hit Wicket"] || [selectedHow isEqualToString: @"LBW"] || [selectedHow isEqualToString: @"Stumped"])
        {
            [self.segmentCtl setSelectedSegmentIndex:1];
            [self.stepper setEnabled:NO];
        }
        else {
            if([selectedHow isEqualToString: @"Timed Out"])
            {
                [self.stepper setEnabled:NO];
            }
            else 
            {
                if(!isFromExtras)
                {
                    [self.stepper setEnabled:YES];
                }
            }
        }
    }
    else if (component==2) 
    {
        if(row==0)
        {
            self.selectedBy = @"NA";
        }
        else 
        {
            self.selectedBy = [NSString stringWithFormat:@"P%d",row];
        }
    }
    else 
    {
        if (row==0) 
        {
            self.selectedWho = self.onStrike;
            [self.segmentCtl setTitle:[[self.who  objectForKey:self.runnersEnd] objectForKey:@"Name"] forSegmentAtIndex:0];
        }
        else 
        {
            self.selectedWho = self.runnersEnd;
            [self.segmentCtl setTitle:[[self.who  objectForKey:self.onStrike] objectForKey:@"Name"] forSegmentAtIndex:0];
        }
        
    }
    if([selectedHow isEqualToString: @"Bowled"] || [selectedHow isEqualToString: @"Handled Ball"] || [selectedHow isEqualToString: @"Hit Ball Twice"] || [selectedHow isEqualToString: @"Hit Wicket"] || [selectedHow isEqualToString: @"LBW"] || [selectedHow isEqualToString: @"Stumped"] || [selectedHow isEqualToString:@"Caught"])
    {
        self.selectedWho = self.onStrike;
        [self.pickerView1 selectRow:0 inComponent:1 animated:YES];
        if( selectedHow != @"Stumped" && selectedHow !=@"Caught" )
        {
            [self.pickerView1 selectRow:0 inComponent:2 animated:YES];
        }
        [self.segmentCtl setTitle:[[self.who  objectForKey:self.runnersEnd] objectForKey:@"Name"] forSegmentAtIndex:0];
    }
    if(isFromExtras && ([selectedHow isEqualToString: @"Bowled"] || [selectedHow isEqualToString: @"Hit Wicket"] || [selectedHow isEqualToString: @"LBW"] ||  [selectedHow isEqualToString:@"Caught"] || [selectedHow isEqualToString:@"Timed Out"]))
    {
        [self.pickerView1 selectRow:8 inComponent:0 animated:YES];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    if (component==0) 
    {
        retval.text = [self.how objectAtIndex:row];
    }
    else if (component==2) 
    {
        if(row==0)
        {
            retval.text = @"NA";
        }
        else 
        {
            retval.text = [[self.by  objectForKey:[NSString stringWithFormat:@"P%d",row]] objectForKey:@"Name"];
        }
    }
    else {
        if (row==0) 
        {
            retval.text = [[self.who  objectForKey:self.onStrike] objectForKey:@"Name"];
        }
        else 
        {
            retval.text = [[self.who  objectForKey:self.runnersEnd] objectForKey:@"Name"];
        }
    }
    retval.font = [UIFont fontWithName:@"Helvetica" size:14 ];
    retval.backgroundColor = [UIColor clearColor];
    return retval;
}

-(IBAction)runsIncrease:(id)sender
{
    runsValue = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    runs.text = [NSString stringWithFormat:@"Runs: %d",[runsValue intValue]];
}

- (IBAction)BatsmanOnStrikeSelected:(id)sender
{
    if([selectedHow isEqualToString: @"Bowled"] || [selectedHow isEqualToString: @"Handled Ball"] || [selectedHow isEqualToString: @"Hit Ball Twice"] || [selectedHow isEqualToString: @"Hit Wicket"] || [selectedHow isEqualToString: @"LBW"] || [selectedHow isEqualToString: @"Stumped"])
    {
        [self.segmentCtl setSelectedSegmentIndex:1];
    }
}

- (IBAction)dismissSelf:(id)sender
{
    NSString *tempStrikeBatsman;
    if ([self.segmentCtl selectedSegmentIndex] == 0)
    {
        if (self.selectedWho == self.onStrike)
        {
            tempStrikeBatsman = self.runnersEnd;
        }
        else
        {
            tempStrikeBatsman = self.onStrike;
        }
    }
    else
    {
        tempStrikeBatsman = @"New Batsman";
    }
    
    [self.delegate OutAction:[self.runsValue intValue] andOutType:self.selectedHow andOutBatsman:self.selectedWho andOutBy:self.selectedBy andOnStrike:tempStrikeBatsman andIsFromExtras:isFromExtras andExtraType:extraType];
}

@end
