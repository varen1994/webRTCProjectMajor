//
//  RecievingCallViewController.m
//  myFinalProject
//
//  Created by Varender on 4/12/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "RecievingCallViewController.h"
#import "MCManager.h"
#import "webRTCViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface RecievingCallViewController ()

@end

@implementation RecievingCallViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _vibrateCount = 0;
    _vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(vibratePhone) userInfo:nil repeats:YES];
   
    self.labelCallerName.text = [NSString stringWithFormat:@"%@ Calling",_peerID.displayName];
    self.acceptCallOutlet.layer.cornerRadius = 30;
    self.declineCallOutlet.layer.cornerRadius = 30;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_vibrateTimer invalidate];
}


-(void)vibratePhone
{
    _vibrateCount +=1;
    if(_vibrateCount<=100)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else
    {
        [self dismissRecievingViewController];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(void)dismissRecievingViewController
{
    [_vibrateTimer invalidate];
    NSError *error = nil;
    NSDictionary *dictionary = @{@"purpose":@"denied Request",@"additional info":@"  "};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSLog(@"%@",_peerID);
    [_mcManager.session sendData:data toPeers:@[_peerID] withMode:MCSessionSendDataReliable error:&error];
    [self.delegate2 callAbortedFromNextSideDelegateMethod];
}


- (IBAction)declineCallAction:(id)sender
{
    [self dismissRecievingViewController];
}


- (IBAction)acceptCallAction:(id)sender
{
    NSDictionary *dictionary = @{@"purpose":@"accepted call"};
    NSError *error = nil;
    [_vibrateTimer invalidate];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0 error:&error];
   [_mcManager.session sendData:data toPeers:@[_peerID] withMode:MCSessionSendDataReliable error:&error];
    [self.delegate callAcceptedDelegateMethod:_peerID andMCManger:_mcManager];
}


@end
