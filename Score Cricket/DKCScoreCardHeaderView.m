//
//  DKCScoreCardHeaderView.m
//  Score Cricket
//
//  Created by Dinesh Challa on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKCScoreCardHeaderView.h"

@implementation DKCScoreCardHeaderView
@synthesize title;
@synthesize matchDetails;
@synthesize inningsTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        title.font = [UIFont fontWithName:@"Helvetica-UltraLight" size:30];
        title.text= @"Score Cricket";
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        
        matchDetails = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 20)];
        matchDetails.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        matchDetails.font = [UIFont fontWithName:@"Helvetica-UltraLight" size:20];
        [self addSubview:matchDetails];
        
        inningsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 18)];
        inningsTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        inningsTitle.font = [UIFont fontWithName:@"Helvetica-UltraLight" size:15];
        [self addSubview:inningsTitle];
        
        title.textAlignment = matchDetails.textAlignment = inningsTitle.textAlignment = UITextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        self.title.backgroundColor = self.matchDetails.backgroundColor = self.inningsTitle.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = self.title.autoresizingMask = self.matchDetails.autoresizingMask = self.inningsTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        
        
    }
    return self;
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
