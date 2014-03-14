//
//  DKCMatchesListCollectionViewController.m
//  Score Cricket
//
//  Created by Dinesh Challa on 9/6/13.
//
//

#import "DKCMatchesListCollectionViewController.h"
#import "DKCCreatePlist.h"
#import "DKCScoringViewController.h"
#import "DKCScoreCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"
#import "DKCMatchesListCollectionViewCell.h"
#import "DKCDynamicCollectionViewFlowLayout.h"

#define matchesListCollectiveViewCellWidth 300
#define matchesListCollectiveViewCellHeight 60

@interface DKCMatchesListCollectionViewController (){
    NSIndexPath *_cellIndexPath;
    BOOL isEditMode;
}
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *tableDataCopy;
@end

@implementation DKCMatchesListCollectionViewController

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
    self.navigationController.navigationBarHidden = NO;
    self.tableDataCopy = [[NSMutableArray alloc] initWithCapacity:0];
    [self.collectionView setBackgroundView:[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"blue_background.png"] stackBlur:60] ]];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        [self.collectionView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
        [self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        //return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped)];
}

- (void)editButtonTapped
{
    isEditMode = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    [self.collectionView reloadData];
}

- (void)doneButtonTapped
{
    isEditMode = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped)];
    [self.collectionView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableData = [DKCCreatePList GetListOfMatches];
    [self.tableDataCopy removeAllObjects];
    if (self.isCompleted)
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
    [self.collectionView reloadData];
	
	
	// May return nil if a tracker has not already been initialized with a
	// property ID.
	id tracker = [[GAI sharedInstance] defaultTracker];
	
	// This screen name value will remain set on the tracker and sent with
	// hits until it is set to a new value or to nil.
	[tracker set:kGAIScreenName
		   value:@"List Of Matches"];
	
	[tracker send:[[GAIDictionaryBuilder createAppView] build]];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tableDataCopy count];
}

// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DKCMatchesListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MatchesListCollectionCell" forIndexPath:indexPath];
    [cell configureCell];
    [cell changeLookBasedOnMode:isEditMode];

   
    NSString *Team1 = [[self.tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"Team1"];
    NSString *Team2 = [[self.tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"Team2"];
    cell.versusLabel.text = [NSString stringWithFormat:@"%@  vs  %@",Team1,Team2];
    cell.timeLabel.text = [[self.tableDataCopy objectAtIndex:[indexPath row]] objectForKey:@"FileName"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(matchesListCollectiveViewCellWidth, matchesListCollectiveViewCellHeight);
}

#pragma mark - Collection View Delegate
#define delay 0.1
#define animationDuration 1
#define animationAmplitude 5
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditMode)
    {
        DKCMatchesListCollectionViewCell *cell = (DKCMatchesListCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        if (cell.frame.size.width != matchesListCollectiveViewCellWidth)
        {
            return;
        }
        
        
        _cellIndexPath = indexPath;
        cell.backgroundCellView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        
        [self bounceView:cell.backgroundCellView amplitude:animationAmplitude duration:animationDuration delegate:YES];
        for (int i =1; i<=4; i++)
        {
            if (indexPath.row - i >= 0)
            {
                DKCMatchesListCollectionViewCell *tempCell = (DKCMatchesListCollectionViewCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - i inSection:0]];
                if (tempCell)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * (i + 1) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        CGFloat modifier = 1 / (1.f * i + 1);
                        modifier = powf(modifier, i);
                        CGFloat subAmplitude = animationAmplitude * modifier;
                        [self bounceView:tempCell.backgroundCellView amplitude:subAmplitude duration:animationDuration delegate:NO];
                    });
                }
            }
            if (indexPath.row + i <= [self.tableDataCopy count])
            {
                DKCMatchesListCollectionViewCell *tempCell = (DKCMatchesListCollectionViewCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + i inSection:0]];
                if (tempCell)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * (i + 1) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        CGFloat modifier = 1 / (1.f * i + 1);
                        modifier = powf(modifier, i);
                        CGFloat subAmplitude = 5 * modifier;
                        [self bounceView:tempCell.backgroundCellView amplitude:subAmplitude duration:animationDuration delegate:NO];
                    });
                }
            }
        }

    }
    else
    {
        NSMutableDictionary *tempObject = [self.tableDataCopy objectAtIndex:indexPath.row];
        
        NSString *fileName = [tempObject valueForKey:@"FileName"];
        [DKCCreatePList DeleteMatchWithFileName:fileName];
        
        [self.tableDataCopy removeObject:tempObject];
        [self.tableData removeObject:tempObject];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        else
        {
            [((DKCDynamicCollectionViewFlowLayout *)self.collectionView.collectionViewLayout) removeDynamicBehavior];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.collectionView setCollectionViewLayout:[[DKCDynamicCollectionViewFlowLayout alloc] init]];
        }
        
        
    }
    
    
}

#define DEGREES(rads) rads * M_PI / 180.f
- (void)bounceView:(UIView *)view amplitude:(CGFloat)amplitude duration:(CGFloat)duration delegate:(BOOL)getDelegateCall {
    CGRect tempFrame = view.frame;
    tempFrame.size.width = matchesListCollectiveViewCellWidth * 2;
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
    DKCMatchesListCollectionViewCell *cell = (DKCMatchesListCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:_cellIndexPath];
    cell.backgroundCellView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    if(self.isCompleted)
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
