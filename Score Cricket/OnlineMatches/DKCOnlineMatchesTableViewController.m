//
//  DKCOnlineMatchesTableViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/16/14.
//
//

#import "DKCOnlineMatchesTableViewController.h"
#import "DKCCreatePlist.h"
#import "DKCScoringViewController.h"
#import "DKCScoreCardViewController.h"
#import "DKCListOfMatchesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"
#import <Parse/Parse.h>


@interface DKCOnlineMatchesTableViewController (){
	NSIndexPath *_cellIndexPath;
}
@property (nonatomic, retain) NSMutableArray *tableData;
@end

@implementation DKCOnlineMatchesTableViewController

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
    
    self.clearsSelectionOnViewWillAppear = YES;
	
	__weak DKCOnlineMatchesTableViewController *wSelf = self;
	
	PFQuery *query = [PFQuery queryWithClassName:@"DevMatches2"];
	[query selectKeys:@[@"Team1", @"Team2",@"Status",@"FileName",@"isCurrent",@"MatchStartDate"]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			// The find succeeded.
			NSLog(@"Successfully retrieved %d scores.", objects.count);
			wSelf.tableData = [objects mutableCopy];
			[wSelf.tableView reloadData];
			
		} else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
	
	[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"blue_background.png"] stackBlur:60] ]];
    self.tableView.backgroundView.frame = self.tableView.frame;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorColor = [UIColor blackColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *Team1 = [[self.tableData objectAtIndex:[indexPath row]] objectForKey:@"Team1"];
    NSString *Team2 = [[self.tableData objectAtIndex:[indexPath row]] objectForKey:@"Team2"];
    cell.bigLabel.text = [NSString stringWithFormat:@"%@  vs  %@",Team1,Team2];
    cell.timeLabel.text = [[self.tableData objectAtIndex:[indexPath row]] objectForKey:@"FileName"];
    
    return cell;
}

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
        if (indexPath.row + i <= [self.tableData count])
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
	PFObject *object = self.tableData[_cellIndexPath.row];
	DKCListOfMatchesCell *cell = (DKCListOfMatchesCell *) [self.tableView cellForRowAtIndexPath:_cellIndexPath];
    cell.bigLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];

	[object fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
		if (!object|| error)
		{
			return ;
		}
		DKCScoreCardViewController *scoreCard = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewController"];
		scoreCard.MatchData = object[@"MatchData"];
        scoreCard.currentInnings = @"FirstInnings";
        self.title = @"Back";
        [self.navigationController pushViewController:scoreCard animated:YES];
	}];
    
    
}

@end
