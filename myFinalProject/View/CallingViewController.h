//
//  CallingViewController.h
//  myFinalProject
//
//  Created by Varender on 4/12/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@protocol DissmissingCallingViewControllerDelegate <NSObject>
-(void)dismissCallingViewControllerMethod;
@end



@interface CallingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong,nonatomic) NSString *callerName;
- (IBAction)declineCall:(id)sender;
@property (strong,nonatomic) MCManager *manager;
@property (nonatomic,strong) MCPeerID *peerID;   /******** peerID tf call is aborted ******/
@property (nonatomic,weak) id <DissmissingCallingViewControllerDelegate> delegate;

@end
