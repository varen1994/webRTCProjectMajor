//
//  CallingViewController.m
//  myFinalProject
//
//  Created by Varender on 4/12/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "CallingViewController.h"
#import "MCManager.h"
#import "webRTCViewController.h"

@interface CallingViewController ()

@end

@implementation CallingViewController

- (void)viewDidLoad  {
    [super viewDidLoad];
    self.labelName.text = self.callerName;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)declineCall:(id)sender
{
    NSError *error = nil;
    NSDictionary *dictionary = @{@"purpose":@"call aborted",@"additional info":@"  "};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [_manager.session sendData:data toPeers:@[_peerID] withMode:MCSessionSendDataReliable error:&error];
    [self.delegate dismissCallingViewControllerMethod];
}


@end
