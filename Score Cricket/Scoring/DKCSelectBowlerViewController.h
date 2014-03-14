//
//  DKCSelectBowlerViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Infrastructure/UIButton+GradientColor.h"

@protocol SelectBowlerViewDelegate <NSObject>

@required
-(void) bowlerSelected:(NSString *)newBowler;

@end

@interface DKCSelectBowlerViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableDictionary *bowlers;
@property (nonatomic, strong) NSString *selectedBowler;
@property (nonatomic, strong) NSMutableString *currentBowler;
@property (nonatomic, strong) id<SelectBowlerViewDelegate> delegate;
@property (nonatomic) BOOL hardStop;

@property (nonatomic, strong) UIImage *backgroundBlurImage;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *selectNextLabel;
-(IBAction)dismissSelf:(id)sender;

@end
