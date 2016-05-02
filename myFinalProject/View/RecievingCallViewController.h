//
//  RecievingCallViewController.h
//  myFinalProject
//
//  Created by Varender on 4/12/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@protocol CallAbortedFromNextSideDelegate <NSObject>
-(void)callAbortedFromNextSideDelegateMethod;
@end


@protocol AcceptedCallDelegate <NSObject>
-(void) callAcceptedDelegateMethod:(MCPeerID *)peerID andMCManger:(MCManager *)mcManger;  /****** if call got accepted so dismiss Recieving call vioew controler and open webRTCViewController ****/
@end



@interface RecievingCallViewController : UIViewController
- (IBAction)declineCallAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *labelCallerName;
- (IBAction)acceptCallAction:(id)sender;

@property (nonatomic,assign)int vibrateCount;
@property (nonatomic,retain)NSTimer *vibrateTimer;
@property (nonatomic,strong)MCManager *mcManager;
@property (nonatomic,strong) MCPeerID *peerID;    /*  Peer ID which is sending data  */
@property (nonatomic,weak) id<AcceptedCallDelegate>delegate;
@property (nonatomic,weak) id<CallAbortedFromNextSideDelegate>delegate2;
@property (strong, nonatomic) IBOutlet UIButton *acceptCallOutlet;
@property (strong, nonatomic) IBOutlet UIButton *declineCallOutlet;


-(void)vibratePhone;
@end
