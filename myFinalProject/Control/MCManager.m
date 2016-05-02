//
//  MCManager.m
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "MCManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <MultipeerConnectivity/MCBrowserViewController.h>
#import "RecievingCallViewController.h"





@implementation MCManager

-(id)init
{
    self = [super init];
    if(self)
    {
        _browser = nil;
        _session = nil;
        _peerID = nil;
        _advertiser = nil;
    }
    return self;
}



-(void)setupPeerConnectionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    _session = [[MCSession alloc]initWithPeer:_peerID];
    _session.delegate = self;
}


-(void)setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc]initWithServiceType:@"chatService" session:_session];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise
{
    if(shouldAdvertise)
    {
      _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:@"chatService" discoveryInfo:nil session:_session];
        [_advertiser start];
    }
    else
    {
        [_advertiser stop];
        _advertiser = nil;
    }
}


// Remote peer changed state.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stateOfTheDevice" object:@{@"state":@(state),@"peerID":peerID}];
    });
}


// Received data from remote peer.
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
    
    dispatch_async(dispatch_get_main_queue(),
    ^{
         NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSString *purpose = [dic valueForKey:@"purpose"];
        if([purpose isEqualToString:@"call aborted"])
        {
            [self StoreCallerLogs:@"missed call" andPeer:peerID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"call aborted" object:[dic valueForKey:@"additional info"]];
        }
        if([purpose isEqualToString:@"call recieved"])
        {
            [self StoreCallerLogs:@"incoming call" andPeer:peerID];
            NSString *roomNo = [dic valueForKey:@"room NO"];
            NSLog(@"%@",roomNo);
            NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];
            [def1 setObject:roomNo forKey:@"roomNo"];
            [def1 synchronize];
            NSDictionary *dictionaryAdditionalInfo2 = @{@"recieved from PeerID":peerID};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"call recieved" object:dictionaryAdditionalInfo2];
        }
        if([purpose isEqualToString:@"denied Request"])
        {
            [self StoreCallerLogs:@"outgoing call" andPeer:peerID];
            NSDictionary *dictionaryAdditionalInfo3  = @{@"recieved from PeerID":peerID,@"additional info":[dic valueForKey:@"additional info"] };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"denied call" object:dictionaryAdditionalInfo3];
        }
        if([purpose isEqualToString:@"accepted call"])
        {
            [self StoreCallerLogs:@"outgoing call" andPeer:peerID];
            NSDictionary *dictionaryAdditionalInfo4  = @{@"recieved from PeerID":peerID};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"accepted call" object:dictionaryAdditionalInfo4];
        }
        if([purpose isEqualToString:@"videoCallDisconnected"])
        {
            NSLog(@"video call disconnect");
            NSDictionary *dictionaryAdditionalInfo5 = @{@"peerID":peerID};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"videoCallDisConnected" object:dictionaryAdditionalInfo5];
        }
        if([purpose isEqualToString:@"userImage"])
        {
            NSLog(@"image Recieved");
            NSString *imageString = [dic valueForKey:@"imageString"];
            NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];
            [def1 setObject:@[imageString] forKey:@"AllImages"];
            [def1 synchronize];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"imageRecieved alert" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertView show];
        }
   });
}


-(void)StoreCallerLogs:(NSString *)callString andPeer:(MCPeerID *)peerID
{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    NSString *timeString = [timeFormatter stringFromDate:localDate];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSDictionary *dictionary;
    NSLog(@"#%@#",peerID.displayName);
    if(peerID.displayName.length>0)
    {
      dictionary = @{@"Date":dateString,@"Time":timeString,@"Type":callString,@"Name":peerID.displayName};
    }
    else
    {
      dictionary = @{@"Date":dateString,@"Time":timeString,@"Type":callString,@"Name":peerID};
    }
    
    if([userdefault valueForKey:@"CallLogs"]==nil)
    {
      [array addObject:dictionary];
      [userdefault setObject:array forKey:@"CallLogs"];
    }
    else
    {
        array = [NSMutableArray arrayWithArray:[userdefault valueForKey:@"CallLogs"]];
        [array addObject:dictionary];
        [userdefault setObject:array forKey:@"CallLogs"];
    }
      [userdefault synchronize];
      NSLog(@"Value added = %@",[userdefault objectForKey:@"CallLogs"]);
}




// Received a byte stream from remote peer.
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
    
}

// Start receiving a resource from remote peer.
- (void)session:(MCSession *)session  didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content
// in a temporary location - the app is responsible for moving the file
// to a permanent location within its sandbox.
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error
{
    
    
}


@end
