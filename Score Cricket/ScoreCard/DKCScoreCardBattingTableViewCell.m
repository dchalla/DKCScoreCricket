//
//  DKCScoreCardBattingTableViewCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCScoreCardBattingTableViewCell.h"

#define leftLabelOriginX 20
#define labelSpacing 5
#define topLabelHeight 30
#define topLabelOriginY 1
#define runsLabelWidth 40
#define ballsLabelWidth 40
#define bottomLabelHeight 20
#define foursLabelWidth 40
#define sixersLabelWidth 40
#define strikeRateLabelWidth 70

@implementation DKCScoreCardBattingTableViewCell
@synthesize nameLabel;
@synthesize runsLabel;
@synthesize ballsLabel;
@synthesize wicketLabel;
@synthesize foursLabel;
@synthesize sixersLabel;
@synthesize strikeRateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX, topLabelOriginY, self.frame.size.width - 2*leftLabelOriginX - runsLabelWidth - ballsLabelWidth - labelSpacing, topLabelHeight)];
        [self addSubview:nameLabel];
        
        ballsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - leftLabelOriginX - ballsLabelWidth, topLabelOriginY, ballsLabelWidth, topLabelHeight)];
        [self addSubview:ballsLabel];
        
        runsLabel = [[UILabel alloc] initWithFrame:CGRectMake(ballsLabel.frame.origin.x - runsLabelWidth , topLabelOriginY, runsLabelWidth, topLabelHeight)];
        [self addSubview:runsLabel];
        
        
        
        wicketLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX, topLabelHeight +topLabelOriginY, self.frame.size.width - 2*leftLabelOriginX - foursLabelWidth - sixersLabelWidth -strikeRateLabelWidth - 3*labelSpacing , bottomLabelHeight)];
        [self addSubview:wicketLabel];
        foursLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelOriginX + wicketLabel.frame.size.width + labelSpacing, topLabelHeight +topLabelOriginY, foursLabelWidth, bottomLabelHeight)];
        [self addSubview:foursLabel];
        sixersLabel = [[UILabel alloc] initWithFrame:CGRectMake(foursLabel.frame.origin.x + foursLabelWidth + labelSpacing, topLabelHeight +topLabelOriginY, sixersLabelWidth, bottomLabelHeight)];
        [self addSubview:sixersLabel];
        strikeRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(sixersLabel.frame.origin.x + sixersLabelWidth + labelSpacing, topLabelHeight +topLabelOriginY, strikeRateLabelWidth, bottomLabelHeight)];
        [self addSubview:strikeRateLabel];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        self.runsLabel.textAlignment = self.ballsLabel.textAlignment = NSTextAlignmentLeft;
        foursLabel.textAlignment = sixersLabel.textAlignment = strikeRateLabel.textAlignment = wicketLabel.textAlignment = NSTextAlignmentLeft;
        self.runsLabel.backgroundColor = self.ballsLabel.backgroundColor = self.nameLabel.backgroundColor = foursLabel.backgroundColor = strikeRateLabel.backgroundColor = sixersLabel.backgroundColor = wicketLabel.backgroundColor = [UIColor clearColor];
        foursLabel.font = sixersLabel.font = strikeRateLabel.font = wicketLabel.font = [UIFont systemFontOfSize:12];
        
        nameLabel.textColor = runsLabel.textColor = ballsLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        
        foursLabel.textColor = sixersLabel.textColor = strikeRateLabel.textColor = wicketLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        foursLabel.autoresizingMask = sixersLabel.autoresizingMask = strikeRateLabel.autoresizingMask = wicketLabel.autoresizingMask = runsLabel.autoresizingMask = ballsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        
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
