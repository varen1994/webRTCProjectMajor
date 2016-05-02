//
//  webRTCViewController.h
//  myFinalProject
//
//  Created by Varender on 4/14/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTCEAGLVideoView.h>
#import <RTCVideoTrack.h>
#import <ARDAppClient.h>
#import "MCManager.h"


@protocol DismissWebRTC <NSObject>
-(void)dismissWebRTCDelegateMethod;
@end

@interface webRTCViewController : UIViewController<ARDAppClientDelegate,RTCEAGLVideoViewDelegate>
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *localView;
@property (strong,nonatomic) RTCVideoTrack *remoteVideoTrack;
@property (strong,nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong,nonatomic) ARDAppClient *client;
@property (strong,nonatomic) NSString *roomNo;
@property (strong,nonatomic) MCManager *myManager;
@property (strong,nonatomic) MCPeerID *senderMCPeerID;
@property (strong, nonatomic) IBOutlet UILabel *labelOfStatusWebRTC;
@property (strong, nonatomic) IBOutlet UIButton *disConnectOutlet;
@property (strong,nonatomic) id<DismissWebRTC>delegate;
- (IBAction)disconnectButtonAction:(id)sender;
@end
