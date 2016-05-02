//
//  MCManager.h
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MCManager : NSObject <MCSessionDelegate>
@property (nonatomic,strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic,strong) MCBrowserViewController *browser;
@property (nonatomic,strong) MCPeerID *peerID;
@property (nonatomic,strong) MCSession *session;

-(void)setupPeerConnectionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)StoreCallerLogs:(NSString *)callString andPeer:(MCPeerID *)peerID;

@end
