//
//  DKCEditTeamViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCEditTeamViewController.h"
#import "UIImage+StackBlur.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

@interface DKCEditTeamViewController ()
{
    NSInteger
    SelectedRow;
}

@end

@implementation DKCEditTeamViewController
@synthesize tableData;
@synthesize txtField;
@synthesize delegate;

- (void)setBackgroundBlurredImage:(UIImage *)backgroundBlurredImage
{
    _backgroundBlurredImage = backgroundBlurredImage;
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:_backgroundBlurredImage]];
    [self addMotionAffect];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self 
                                                                                            action:@selector(dismissSelf:)];
    UIImage *tempBackgroundImage = nil;
    if (_fromScoringViewController)
    {
        tempBackgroundImage = [UIImage imageNamed:@"blurredBackgroundScoring.png"];
    }
    else
    {
        tempBackgroundImage = [UIImage imageNamed:@"blurredBackgroundCreateMatch.png"];
    }
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:tempBackgroundImage]];
    self.tableView.backgroundView.frame = self.tableView.frame;
    CGRect tempBackgroundViewFrme = self.tableView.backgroundView.frame;
    tempBackgroundViewFrme.origin.x-=15;
    tempBackgroundViewFrme.origin.y-=15;
    tempBackgroundViewFrme.size.width+=30;
    tempBackgroundViewFrme.size.height+=30;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.txtField=[[UITextField alloc]initWithFrame:CGRectZero];
    self.txtField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.txtField.autoresizesSubviews=YES;
    [self.txtField setBorderStyle:UITextBorderStyleRoundedRect];
    self.txtField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    SelectedRow=-1;
    
    [self addMotionAffect];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	// May return nil if a tracker has not already been initialized with a
	// property ID.
	id tracker = [[GAI sharedInstance] defaultTracker];
	
	// This screen name value will remain set on the tracker and sent with
	// hits until it is set to a new value or to nil.
	[tracker set:kGAIScreenName
		   value:@"List Of Matches"];
	
	[tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    [self.tableView.backgroundView addMotionEffect:group];
}

-(void) dismissSelf:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(SelectedRow >-1)
    {
        if(SelectedRow == 0)
        {
            NSString *tempTeamName = [self.tableData objectForKey:@"TeamName"];
            tempTeamName=self.txtField.text;
            [self.tableData setObject:tempTeamName forKey:@"TeamName"];
            
        }
        else 
        {
            NSString *tempPlayer = [[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",SelectedRow]]objectForKey:@"Name"];
            tempPlayer=self.txtField.text;
            [[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",SelectedRow]] setObject:tempPlayer forKey:@"Name"];
        }
        [self.txtField removeFromSuperview];
        [self.tableView reloadData];
    }
    [[self delegate] dismissEditTeam];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell==nil)
    {
        cell = [[DKCEditTeamCell alloc] init];
        //cell.contentView.backgroundColor = [UIColor clearColor];
        //cell.textLabel.backgroundColor=[UIColor clearColor];
        if ([indexPath row]%2==0) 
        {
            if ([indexPath row]==0) 
            {
                UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
                bg.backgroundColor = [UIColor clearColor];
                bg.alpha=0.8;
               // cell.backgroundView = bg;
                cell.textLabel.textAlignment=UITextAlignmentCenter;
            }
            else
            {
                UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
                bg.backgroundColor = [[UIColor alloc] initWithRed:((float)(4.0 / 255.0)) green:((float)(102.0 / 255.0)) blue:((float)(7.0 / 255.0)) alpha:0.0f];
                //cell.backgroundView = bg;
            }
        }
        else {
            UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
            bg.backgroundColor = [[UIColor alloc] initWithRed:((float)(4.0 / 255.0)) green:((float)(102.0 / 255.0)) blue:((float)(7.0 / 255.0)) alpha:0.0f];
            //cell.backgroundView = bg;
        }
    }
    
    if(indexPath.row==0)
    {
        cell.textLabel.text = [self.tableData objectForKey:@"TeamName"];
    }
    else 
    {
        cell.textLabel.text=[[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",indexPath.row]]objectForKey:@"Name"];
    }
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(SelectedRow!=[indexPath row])
    {
        if(SelectedRow >-1)
        {
            if(SelectedRow == 0)
            {
                NSString *tempTeamName = [self.tableData objectForKey:@"TeamName"];
                tempTeamName=self.txtField.text;
                [self.tableData setObject:tempTeamName forKey:@"TeamName"];
                [self.tableView reloadData];
                
            }
            else 
            {
                NSString *tempPlayer = [[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",SelectedRow]]objectForKey:@"Name"];
                tempPlayer=self.txtField.text;
                [[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",SelectedRow]] setObject:tempPlayer forKey:@"Name"];
                [self.tableView reloadData];
            }
            
        }
        
        
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.txtField.frame=cell.frame;
        if(indexPath.row==0)
        {
            self.txtField.text=[self.tableData objectForKey:@"TeamName"];
        }
        else 
        {
            self.txtField.text=[[self.tableData objectForKey: [NSString stringWithFormat:@"P%d",indexPath.row]]objectForKey:@"Name"];
        }
        if (![self.txtField superview])
        {
            [self.view addSubview:self.txtField];
        }
        
        [self.txtField becomeFirstResponder];
        SelectedRow = [indexPath row];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

@end
