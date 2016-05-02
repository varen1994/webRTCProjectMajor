//
//  webRTCViewController.m
//  myFinalProject
//
//  Created by Varender on 4/14/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "webRTCViewController.h"
#import <ARDAppClient.h>
#import <AVFoundation/AVFoundation.h>

@interface webRTCViewController ()
{
    
    AVAudioSession *session;
}
@end


@implementation webRTCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    self.client = [[ARDAppClient alloc]initWithDelegate:self];
    [self.client setServerHostUrl:@"https://apprtc.appspot.com"];
    NSLog(@"room no = %@",self.roomNo);
    [self.client connectToRoomWithId:self.roomNo options:nil];
    session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setMode:AVAudioSessionModeVoiceChat error:&error];
     [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self disconnect];
}



/************* delegates of webRTC  **********/
-(void)appClient:(ARDAppClient *)client didChangeState:(ARDAppClientState)state
{
   if(state==kARDAppClientStateConnected)
   {
       self.labelOfStatusWebRTC.text = @"Connected";
   }
    if(state==kARDAppClientStateConnecting)
    {
       self.labelOfStatusWebRTC.text = @"Connecting";
    }
    
    if(state==kARDAppClientStateDisconnected)
    {
        [self disconnect];
        self.labelOfStatusWebRTC.text = @"disconnected";
        [self.delegate dismissWebRTCDelegateMethod];
    }
}


-(void)appClient:(ARDAppClient *)client didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack
{
    self.localVideoTrack = localVideoTrack;
    [self.localVideoTrack addRenderer:self.localView];
    
}

-(void)appClient:(ARDAppClient *)client didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack
{
    self.remoteVideoTrack = remoteVideoTrack;
    [self.remoteVideoTrack addRenderer:self.remoteView];
}


-(void)appClient:(ARDAppClient *)client didError:(NSError *)error
{
    [self disconnect];
    [self.delegate dismissWebRTCDelegateMethod];
}


-(void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size
{
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




- (IBAction)disconnectButtonAction:(id)sender
{
    [self disconnect];
    NSDictionary *dic = @{@"purpose":@"videoCallDisconnected"};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    [self.myManager.session sendData:data toPeers:@[_senderMCPeerID] withMode:MCSessionSendDataReliable error:&error];
    [self.delegate dismissWebRTCDelegateMethod];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
    [self.client disconnect];
    [self.delegate dismissWebRTCDelegateMethod];
}


-(void)disconnect
{
    if (self.client)
    {
        if (self.localVideoTrack) [self.localVideoTrack removeRenderer:self.localView];
        if (self.remoteVideoTrack) [self.remoteVideoTrack removeRenderer:self.remoteView];
        self.localVideoTrack = nil;
        [self.localView renderFrame:nil];
        self.remoteVideoTrack = nil;
        [self.remoteView renderFrame:nil];
        [self.client disconnect];
    }
}


@end
