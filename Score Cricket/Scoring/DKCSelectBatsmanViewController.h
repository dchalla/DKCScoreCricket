//
//  DKCSelectBatsmanViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIButton+GradientColor.h"

@protocol SelectBatsmanViewDelegate <NSObject>

@required
-(void) batsmanSelected:(NSString *)newBatsman andForBatsman:(NSString *)oldBatsman andOutType:(NSString *)oldBatsmanOutType;
-(void) batsmanSelectedAfterOut:(NSString *)newBatsman andForBatsman:(NSString *)oldBatsman  andOutData:(NSMutableDictionary *)outData;

@end

@interface DKCSelectBatsmanViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableDictionary *batsmans;
@property (nonatomic, strong) NSMutableArray *notOutbatsmans;
@property (nonatomic, strong) NSString *selectedBatsman;
@property (nonatomic, strong) NSMutableString *onStrikeBatsman;
@property (nonatomic, strong) NSMutableString *runnersEndBatsman;
@property (nonatomic, strong) id<SelectBatsmanViewDelegate> delegate;
@property (nonatomic) BOOL changeBatsman;

@property (nonatomic, strong) NSString *forBatsmanChange;

@property (nonatomic, strong) NSMutableDictionary *outData;

@property (nonatomic, strong) UIImage *backgroundBlurImage;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *selectNextLabel;

-(IBAction)dismissSelf:(id)sender;

-(IBAction)dismissSelfCancelPressed:(id)sender;


@end
