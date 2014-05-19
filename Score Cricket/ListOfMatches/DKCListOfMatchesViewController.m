//
//  DKCListOfMatchesViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCListOfMatchesViewController.h"
#import "DKCCreatePlist.h"
#import "DKCScoringViewController.h"
#import "DKCScoreCardViewController.h"
#import "DKCListOfMatchesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"
#import "DKCBackgroundImage.h"

@interface DKCListOfMatchesViewController ()
{
    NSIndexPath *_cellIndexPath;
}

@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *tableDataCopy;

@end

@implementation DKCListOfMatchesViewController
@synthesize tableData;
@synthesize isCompleted;
@synthesize tableDataCopy;

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
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[DKCBackgroundImage backgroundImage] ]];
    self.tableView.backgroundView.frame = self.tableView.frame;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBarHidden = NO;
    
    tableDataCopy = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableView.separatorColor = [UIColor blackColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{/*
    CGFloat scrollOffset = scrollView.contentOffset.y + 44;
    int i =5;
    for (DKCListOfMatchesCell *tempCell in [self.tableView visibleCells])
    {
        i++;
        CGRect tempCellBigLabelFrame = tempCell.bigLabel.frame;
        tempCellBigLabelFrame.origin.y = 5 - scrollOffset/i;
        
                tempCell.bigLabel.frame = tempCellBigLabelFrame;
    }
   */ 
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    tableData = [DKCCreatePList GetListOfMatches];
    [tableDataCopy removeAllObjects];
    if (isCompleted) 
    {
        for(int i=[self.tableData count]-1;i>=0;i--)
        {
            NSMutableDictionary *tempDict = [self.tableData objectAtIndex:i];
            if (![[tempDict objectForKey:@"isCurrent"] isEqualToString:@"current"]) 
            {
                [self.tableDataCopy addObject:tempDict];
            }
        }
        self.title = @"Completed";
    }
    else 
    {
        for(int i=[self.tableData count]-1;i>=0;i--)
        {
            NSMutableDictionary *tempDict = [self.tableData objectAtIndex:i];
            if ([[tempDict objectForKey:@"isCurrent"] isEqualToString:@"current"]) 
            {
                [self.tableDataCopy addObject:tempDict];
            }
        }
        self.title = @"In Progress";
    }
    [self.tableView reloadData];
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
    return [tableDataCopy count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DKCListOfMatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[DKCListOfMatchesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.bigLabel.alpha = 1.0;
    cell.clipViewTop.alpha = 1.0;
    NSString *Team1 = [[tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"Team1"];
    NSString *Team2 = [[tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"Team2"];
    cell.bigLabel.text = [NSString stringWithFormat:@"%@  vs  %@",Team1,Team2];
    cell.timeLabel.text = [[tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"FileName"];
    
    return cell;
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        NSMutableDictionary *tempObject = [self.tableDataCopy objectAtIndex:indexPath.row];
        
        NSString *fileName = [tempObject valueForKey:@"FileName"];
        [DKCCreatePList DeleteMatchWithFileName:fileName];
        
        [self.tableDataCopy removeObject:tempObject];
        [self.tableData removeObject:tempObject];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
 
 }
 

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
#define delay 0.1
#define animationDuration 1
#define animationAmplitude 5


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKCListOfMatchesCell *cell = (DKCListOfMatchesCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.width != self.view.frame.size.width)
    {
        return;
    }
    _cellIndexPath = indexPath;
    cell.bigLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    [self bounceView:cell amplitude:animationAmplitude duration:animationDuration delegate:YES];
    for (int i =1; i<=4; i++)
    {
        if (indexPath.row - i >= 0)
        {
            DKCListOfMatchesCell *tempCell = (DKCListOfMatchesCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - i inSection:0]];
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
        if (indexPath.row + i <= [self.tableDataCopy count])
        {
            DKCListOfMatchesCell *tempCell = (DKCListOfMatchesCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + i inSection:0]];
            if (tempCell)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * (i + 1) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    CGFloat modifier = 1 / (1.f * i + 1);
                    modifier = powf(modifier, i);
                    CGFloat subAmplitude = 5 * modifier;
                    [self bounceView:tempCell amplitude:subAmplitude duration:animationDuration delegate:NO];
                });
            }
        }
    }
    
}

#define DEGREES(rads) rads * M_PI / 180.f
- (void)bounceView:(UIView *)view amplitude:(CGFloat)amplitude duration:(CGFloat)duration delegate:(BOOL)getDelegateCall {
    CGRect tempFrame = view.frame;
    tempFrame.size.width = self.view.frame.size.width * 2;
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
    DKCListOfMatchesCell *cell = (DKCListOfMatchesCell *) [self.tableView cellForRowAtIndexPath:_cellIndexPath];
    cell.bigLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    if(isCompleted)
    {
        DKCScoreCardViewController *scoreCard = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewController"];
        scoreCard.MatchData = [DKCCreatePList ReadPlistDictionaryWithName:[[self.tableDataCopy objectAtIndex:[_cellIndexPath row]] objectForKey:@"FileName"]];
        scoreCard.currentInnings = @"FirstInnings";
        self.title = @"Back";
        [self.navigationController pushViewController:scoreCard animated:YES];
    }
    else
    {
        DKCScoringViewController *score = [self.storyboard instantiateViewControllerWithIdentifier:@"Scoring"];
        score.MatchData = [DKCCreatePList ReadPlistDictionaryWithName:[[self.tableDataCopy objectAtIndex:[_cellIndexPath row]] objectForKey:@"FileName"]];
        self.title = @"Back";
        [self.navigationController pushViewController:score animated:YES];
        
    }
}

@end
