//
//  CallLogTableViewCell.h
//  myFinalProject
//
//  Created by Varender on 4/28/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallLogTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UILabel *labelType;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;


@end
