//
//  DKCScoreTableViewCell.h
//  Score Cricket
//
//  Created by Dinesh Challa on 5/16/14.
//
//

#import <UIKit/UIKit.h>

@interface DKCScoreTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *team1Name;
@property (nonatomic, weak) IBOutlet UILabel *team2Name;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *team1ScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *team2ScoreLabel;
@property (nonatomic, weak) IBOutlet UIView *backgroundCellView;

@end
