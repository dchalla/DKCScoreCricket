//
//  DKCOutViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIButton+GradientColor.h"
#import "../Infrastructure/UIView+UIView_RoundCorner.h"

@protocol OutViewDelegate <NSObject>

@required
- (void) OutAction:(int)addRuns andOutType:(NSString *)outType andOutBatsman:(NSString *)outBatsman andOutBy:(NSString *)outByFielder andOnStrike:(NSString *)outOnStrikeBatsman andIsFromExtras:(BOOL)isFromExtras andExtraType:(NSString *)extraType;

@end

@interface DKCOutViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView1;
@property (nonatomic, strong) IBOutlet UILabel *runs;
@property (nonatomic, strong) NSNumber *runsValue;
@property (nonatomic, strong) NSMutableArray *how;
@property (nonatomic, strong) NSMutableDictionary *who;
@property (nonatomic, strong) NSMutableDictionary *by;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) NSString *bowler;
@property (nonatomic, strong) NSString *onStrike;
@property (nonatomic, strong) NSString *runnersEnd;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentCtl;

@property (nonatomic, strong) NSString *selectedHow;
@property (nonatomic, strong) NSString *selectedWho;
@property (nonatomic, strong) NSString *selectedBy;

@property (nonatomic) BOOL isFromExtras;
@property (nonatomic, strong) NSString *extraType;

@property (nonatomic, strong) id<OutViewDelegate> delegate;

@property (nonatomic, strong) UIImage *backgroundBlurImage;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *onStrikeLabel;
@property (nonatomic, strong) IBOutlet UILabel *howWhoByLabel;

-(IBAction)runsIncrease:(id)sender;
- (IBAction)BatsmanOnStrikeSelected:(id)sender;
- (IBAction)dismissSelf:(id)sender;

@end
