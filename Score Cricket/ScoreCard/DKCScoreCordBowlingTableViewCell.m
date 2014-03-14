//
//  DKCScoreCordBowlingTableViewCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCScoreCordBowlingTableViewCell.h"

#define leftLabelOriginX 20
#define labelSpacing 5
#define topLabelHeight 30
#define topLabelOriginY 1
#define runsLabelWidth 40
#define oversLabelWidth 40
#define bottomLabelHeight 20
#define foursLabelWidth 50
#define sixersLabelWidth 50
#define economyRateLabelWidth 60
#define dotlabelWidth 50
#define extrasLabelWidth 50

@implementation DKCScoreCordBowlingTableViewCell
@synthesize nameLabel;
@synthesize runsLabel;
@synthesize oversLabel;
@synthesize foursLabel;
@synthesize sixersLabel;
@synthesize dotLabel;
@synthesize EconomyRateLabel;
@synthesize ExtrasLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX, topLabelOriginY, self.frame.size.width - 2*leftLabelOriginX - runsLabelWidth - oversLabelWidth - labelSpacing, topLabelHeight)];
        [self addSubview:nameLabel];
        
        oversLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - leftLabelOriginX - oversLabelWidth, topLabelOriginY, oversLabelWidth, topLabelHeight)];
        [self addSubview:oversLabel];
        
        runsLabel = [[UILabel alloc] initWithFrame:CGRectMake(oversLabel.frame.origin.x - runsLabelWidth , topLabelOriginY, runsLabelWidth, topLabelHeight)];
        [self addSubview:runsLabel];
        
        dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX, topLabelOriginY + topLabelHeight, dotlabelWidth, bottomLabelHeight)];
        [self addSubview:dotLabel];
        
        ExtrasLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX + dotlabelWidth + labelSpacing, topLabelOriginY + topLabelHeight, extrasLabelWidth, bottomLabelHeight)];
        [self addSubview:ExtrasLabel];

        foursLabel = [[UILabel alloc] initWithFrame:CGRectMake(ExtrasLabel.frame.origin.x + extrasLabelWidth + labelSpacing, topLabelOriginY + topLabelHeight, foursLabelWidth, bottomLabelHeight)];
        [self addSubview:foursLabel];
        
        sixersLabel = [[UILabel alloc] initWithFrame:CGRectMake(foursLabel.frame.origin.x + foursLabelWidth + labelSpacing, topLabelOriginY + topLabelHeight, sixersLabelWidth, bottomLabelHeight)];
        [self addSubview:sixersLabel];
        
        EconomyRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(sixersLabel.frame.origin.x + sixersLabelWidth, topLabelOriginY + topLabelHeight, economyRateLabelWidth, bottomLabelHeight)];
        [self addSubview:EconomyRateLabel];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        self.oversLabel.textAlignment = self.runsLabel.textAlignment = NSTextAlignmentLeft;
        foursLabel.textAlignment = sixersLabel.textAlignment = EconomyRateLabel.textAlignment = dotLabel.textAlignment = ExtrasLabel.textAlignment = NSTextAlignmentCenter;
        
        self.oversLabel.backgroundColor = self.runsLabel.backgroundColor = self.nameLabel.backgroundColor = foursLabel.backgroundColor = EconomyRateLabel.backgroundColor = sixersLabel.backgroundColor = dotLabel.backgroundColor = ExtrasLabel.backgroundColor = [UIColor clearColor];
        
        foursLabel.font = sixersLabel.font = EconomyRateLabel.font = dotLabel.font = ExtrasLabel.font = [UIFont systemFontOfSize:12];
        
        nameLabel.textColor = runsLabel.textColor = oversLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        
        foursLabel.textColor = sixersLabel.textColor = EconomyRateLabel.textColor = dotLabel.textColor = ExtrasLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        foursLabel.autoresizingMask = sixersLabel.autoresizingMask = EconomyRateLabel.autoresizingMask = dotLabel.autoresizingMask = runsLabel.autoresizingMask = oversLabel.autoresizingMask = ExtrasLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        }
        else
        {
            UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, self.backgroundView.frame.size.width - 2*9, 56)];
            backgroundColorView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
            backgroundColorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.backgroundView addSubview:backgroundColorView];
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }

        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftLabelOriginX, 55, self.frame.size.width - 2*leftLabelOriginX, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:lineView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
