//
//  DKCEditTeamCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCEditTeamCell.h"

@implementation DKCEditTeamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor=[UIColor whiteColor];
        self.textLabel.textAlignment=UITextAlignmentLeft;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
