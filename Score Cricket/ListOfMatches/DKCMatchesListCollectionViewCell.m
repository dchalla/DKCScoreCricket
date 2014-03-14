//
//  DKCMatchesListCollectionViewCell.m
//  Score Cricket
//
//  Created by Dinesh Challa on 9/6/13.
//
//

#import "DKCMatchesListCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DKCMatchesListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)configureCell
{
    if (_backgroundCellView)
    {
        [self.editlabel removeFromSuperview];
        return;
    }
    self.backgroundCellView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backgroundCellView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:self.backgroundCellView];
    [self.versusLabel removeFromSuperview];
    [self.backgroundCellView addSubview:self.versusLabel];
    [self.timeLabel removeFromSuperview];
    [self.backgroundCellView addSubview:self.timeLabel];
    
}

#define editLabelHeight 20
- (void)changeLookBasedOnMode:(BOOL)isEditMode
{
    if (isEditMode)
    {
        [self.editlabel removeFromSuperview];
        self.backgroundCellView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
        self.editlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (self.backgroundCellView.frame.size.height - editLabelHeight)/2, editLabelHeight, editLabelHeight)];
        self.editlabel.backgroundColor = [UIColor redColor];
        self.editlabel.layer.cornerRadius = editLabelHeight/2;
        self.editlabel.textColor = [UIColor whiteColor];
        self.editlabel.text = @"-";
        self.editlabel.textAlignment = NSTextAlignmentCenter;
        self.editlabel.font = [UIFont systemFontOfSize:20];
        [self.backgroundCellView addSubview:self.editlabel];
    }
    else
    {
        self.backgroundCellView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self.editlabel removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
