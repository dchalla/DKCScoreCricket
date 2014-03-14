//
//  DKCAdditionalRunsViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIButton+GradientColor.h"

@protocol AdditionalRunsViewDelegate <NSObject>

@required
- (void) AddAdditionalRuns:(int)addRuns andExtraType:(NSString *)extraType andIsOut:(BOOL)isOut andRunsFromBat:(BOOL)isRunsFromBat;

@end

@interface DKCAdditionalRunsViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *outOrNotSegment;
@property (nonatomic, strong) IBOutlet UILabel *outLabel;

@property (nonatomic, strong) IBOutlet UISegmentedControl *runsFromBatSegment;
@property (nonatomic, strong) IBOutlet UILabel *runsFromBatLabel;

@property (nonatomic, strong) NSMutableArray *runsArray;
@property (nonatomic, strong) NSString *ExtraType; 
@property (nonatomic, strong) NSNumber *runsSelected;

@property (nonatomic, strong) id<AdditionalRunsViewDelegate> delegate;
@property (nonatomic, strong) UIImage *backgroundBlurImage;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *additionalRunsLabel;

-(IBAction)dismissSelf:(id)sender;

@end
