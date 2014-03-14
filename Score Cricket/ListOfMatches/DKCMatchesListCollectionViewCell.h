//
//  DKCMatchesListCollectionViewCell.h
//  Score Cricket
//
//  Created by Dinesh Challa on 9/6/13.
//
//

#import <UIKit/UIKit.h>

@interface DKCMatchesListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *versusLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UIView *backgroundCellView;
@property (nonatomic, strong) UILabel *editlabel;

- (void)configureCell;
- (void)changeLookBasedOnMode:(BOOL)isEditMode;

@end
