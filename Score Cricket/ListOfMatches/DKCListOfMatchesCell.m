//
//  DKCListOfMatchesCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCListOfMatchesCell.h"

@implementation DKCListOfMatchesCell
@synthesize clipViewTop;
@synthesize bigLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        
        bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 60)];
        bigLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        bigLabel.textColor = [UIColor whiteColor];
        bigLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:bigLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.bigLabel.frame.size.width, 15)];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [self.bigLabel addSubview:timeLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
