//
//  DKCScoreCardBattingTableViewCell.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKCScoreCardBattingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *runsLabel;
@property (nonatomic, strong) UILabel *ballsLabel;
@property (nonatomic, strong) UILabel *wicketLabel;
@property (nonatomic, strong) UILabel *foursLabel;
@property (nonatomic, strong) UILabel *sixersLabel;
@property (nonatomic, strong) UILabel *strikeRateLabel;

@end
