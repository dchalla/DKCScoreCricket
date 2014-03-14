//
//  DKCMatchesListCollectionViewController.h
//  Score Cricket
//
//  Created by Dinesh Challa on 9/6/13.
//
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

@interface DKCMatchesListCollectionViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) BOOL isCompleted;
@end
