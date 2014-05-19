//
//  DKCScoreTableViewCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/16/14.
//
//

#import "DKCScoreTableViewCell.h"

@implementation DKCScoreTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
