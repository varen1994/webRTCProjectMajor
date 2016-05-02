//
//  ContactSecondViewController.m
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "ContactSecondViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#include <SystemConfiguration/CaptiveNetwork.h>
#import "ContactsTableViewCell.h"
#import "CallingViewController.h"
#import "webRTCViewController.h"
#import "RecievingCallViewController.h"
#import "MCManager.h"



/*     CBCentralManager deligate is added to check weather bluetooth is off or on            */
/*     MCBrowserViewController delegate is added to check the devices connected and add them  to table view   */
/*     Alerts are being used to tell weather the video call is being disconnected or not         */
/*     UITable view source is added to send data when a cell is being cliclked and number of rows and sectiuons it contains  */


@interface ContactSecondViewController()
<  CBCentralManagerDelegate,
   MCBrowserViewControllerDelegate,
   UITableViewDelegate,
   UIAlertViewDelegate,
   UITableViewDataSource,
   AcceptedCallDelegate,
   DissmissingCallingViewControllerDelegate,
 CallAbortedFromNextSideDelegate,
 DismissWebRTC
>
{
    NSMutableArray *arrDevicesConnected;
    NSMutableArray *peerDeviceConnected;
    NSMutableDictionary *imageData;
    NSString *roomNo;
}
@end


@implementation ContactSecondViewController


/*    view controller will load */
- (void)viewDidLoad {
    [super viewDidLoad];
    _mcManager = [[MCManager alloc]init];
    
    
    
    arrDevicesConnected = [[NSMutableArray alloc]init];
    peerDeviceConnected = [[NSMutableArray alloc]init];
    imageData = [[NSMutableDictionary alloc]init];
    [_contactTableView setDelegate:self];
    [_contactTableView setDataSource:self];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *nameArray = [defs objectForKey:@"NameOfTheUser"];
    NSString *nameString = nameArray[0];
    if([nameString length]==0)  {
        nameString = [[UIDevice currentDevice]name];
    }
    [_mcManager setupPeerConnectionWithDisplayName:nameString];
    [_mcManager advertiseSelf:YES];
    _cbManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                                                                              forKey:CBCentralManagerOptionShowPowerAlertKey]];
    
    /*     Notification coming from MCManager that whats the state of the device i.e either its connectde or not   */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peerDidChangeExistingState:) name:@"stateOfTheDevice" object:nil];
    /*     notification is being recieved from MC manager that call is being recieved message to this device   */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callReceived:) name:@"call recieved" object:nil];
    /*      notication message from Mcmanager that either the call is  being accepted on this side  */
    
    /*     notification message that eiher the video call got disconnected or not */
}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];
    imageData = [def1 objectForKey:@"imageData"];
}


-(void)dismissWebRTCDelegateMethod
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*************      Calling view controller      ************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    roomNo = [NSString stringWithFormat:@"%uAddvalDot",arc4random()];
    NSDictionary *dictionary = @{@"purpose":@"call recieved",@"room NO":roomNo};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];
    [def1 setObject:roomNo forKey:@"roomNo"];
    [def1 synchronize];
    
    NSArray *sendingArray = @[peerDeviceConnected[indexPath.row]];
    [_mcManager.session sendData:data toPeers:sendingArray  withMode:MCSessionSendDataUnreliable error:&error];
    [_contactTableView reloadData];
    NSLog(@"PRESENTING CALLING VIEW CONTROLLER");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CallingViewController *callingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"callingViewController"];
    callingViewController.callerName = arrDevicesConnected[indexPath.row];
    callingViewController.manager = _mcManager;
    callingViewController.peerID = peerDeviceConnected[indexPath.row];
    callingViewController.delegate = self;
    NSLog(@"adding observer accepted call and denied call");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callAccepted:) name:@"accepted call" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deniedCall:) name:@"denied call" object:nil];
    [self presentViewController:callingViewController animated:NO completion:nil];
}


/*********** delegate method to dismiss   CALLING VIEW controller *******/
-(void)dismissCallingViewControllerMethod
{
    NSLog(@"DISMISSING CALLING VIEW CONTROLLER");
    NSLog(@"removing observer accepted call and denied call");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"accepted call" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"denied call" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)callAccepted:(NSNotification *)notification          /********* call accepted from next device *****/
{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"DISMISSING CALLING VIEW CONTROLLER");
    MCPeerID *messageBeingRecievedFrom = [notification.object valueForKey:@"recieved from PeerID"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    webRTCViewController *startwebrtcViewController =   [storyBoard instantiateViewControllerWithIdentifier:@"startWebRTC"];
    NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];
    startwebrtcViewController.roomNo = [def1 objectForKey:@"roomNo"];
    startwebrtcViewController.myManager = self.mcManager;
    startwebrtcViewController.senderMCPeerID =   messageBeingRecievedFrom;
    startwebrtcViewController.delegate = self;
        NSLog(@"removing observer accepted call and denied call");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"accepted call" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"denied call" object:nil];
    NSLog(@"adding observer videoCallDisconnecetd");
    NSLog(@"PRESENTING VIDEO RTC VIEW CONTROLLER");
    [self presentViewController:startwebrtcViewController animated:YES completion:nil];
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    [_mcManager advertiseSelf:NO];
}


-(void)deniedCall:(NSNotification *)notification
{
    NSLog(@"removing observer accepted call and denied call");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"accepted call" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"denied call" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*****************  RECEIVED CALL ********************/
-(void)callReceived:(NSNotification *)notification
{
    NSDictionary *additionalInfo = notification.object;
    if (self.presentedViewController) {
      [self dismissViewControllerAnimated:NO completion:nil];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSLog(@"PRESENTING RECIEVING VIEW CONTROLLER");
    RecievingCallViewController *recievingCallViewController = [storyboard instantiateViewControllerWithIdentifier:@"RecievingCallViewController"];
    recievingCallViewController.mcManager = _mcManager;
    recievingCallViewController.delegate = self;
    recievingCallViewController.delegate2 = self;
    recievingCallViewController.peerID = [additionalInfo valueForKey:@"recieved from PeerID"];
    NSLog(@"adding observer call aborted");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callAborted:) name:@"call aborted" object:nil];
    [self.navigationController presentViewController:recievingCallViewController animated:YES completion:nil];
}



/************* REPRESENT RECIEVING AND CALLING VIEW CONTROLLER **********/
-(void)callAborted:(NSNotification *)notification
{
    NSLog(@"REmoving observer call aborted ");
    NSLog(@"DISMISSING RECIEVING VIEW CONTROLLER");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"call aborted" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)callAcceptedDelegateMethod:(MCPeerID *)peerID andMCManger:(MCManager *)mcManger
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    webRTCViewController *startwebrtcViewController =   [storyBoard instantiateViewControllerWithIdentifier:@"startWebRTC"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"call aborted" object:nil];
    NSUserDefaults *def1 = [NSUserDefaults standardUserDefaults];     /****  room NO being recieved from next side and being stored  *****/
    startwebrtcViewController.roomNo = [def1 objectForKey:@"roomNo"];
    startwebrtcViewController.senderMCPeerID = peerID;
    startwebrtcViewController.myManager = mcManger;
    startwebrtcViewController.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoCallDisconnected:) name:@"videoCallDisConnected" object:nil];
    NSLog(@"adding observer videoCallDisConnected");
    NSLog(@"PRESENTING VIDEO RTC VIEW CONTROLLER");
   [self presentViewController:startwebrtcViewController animated:YES completion:nil];
}

#pragma mark video Call Disconnected Message Recieved
-(void)videoCallDisconnected:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"videoCallDisConnected" object:nil];
}


-(void)callAbortedFromNextSideDelegateMethod
{
    NSLog(@"Removing observer call aborted and recieved");
    NSLog(@"DISMISSING RECIEVING VIEW CONTROLLER");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"call aborted" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/***************** TABLE VIEW DELEGATES  ****************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([peerDeviceConnected count]==0)
    {
        self.contactTableView.hidden = YES;
    }
    else
    {
        self.contactTableView.hidden = NO;
    }
    return [arrDevicesConnected count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsTableViewCell *contactViewCell = (ContactsTableViewCell *)[_contactTableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    contactViewCell.labelContactName.text = arrDevicesConnected[indexPath.row];
   [contactViewCell.peerImage setBackgroundImage:[UIImage imageNamed:@"profileImage.jpg"] forState:UIControlStateNormal];
    return contactViewCell;
}



/******************* ADD DEVICES  AND REMOVE DEVICES IF STATE OF DEVICE GOT CHANGED ********/
-(void)peerDidChangeExistingState:(NSNotification *)notification
{
    NSDictionary *stateChangeDictionary = notification.object;
    MCSessionState statePeer = [[stateChangeDictionary valueForKey:@"state"] integerValue];
    MCPeerID *peerID = [stateChangeDictionary objectForKey:@"peerID"];
    
    if(statePeer == MCSessionStateNotConnected)
    {
        [arrDevicesConnected removeObject:peerID.displayName];
        [peerDeviceConnected removeObject:peerID];
        [_contactTableView reloadData];
        UIViewController *view = self.presentedViewController;
        if([view isKindOfClass:[CallingViewController class]]  || [view isKindOfClass:[RecievingCallViewController class]] )
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if (statePeer == MCSessionStateConnected) {
        [peerDeviceConnected addObject:peerID];
        [arrDevicesConnected addObject:peerID.displayName];
        [_contactTableView reloadData];
    }
    
}


/********** MCBROWSER ACTIONS DELEGATES CANCEL AND DELETE  THEN DISMISS BROWSER VIEW CONTROLLER ********/
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    NSLog(@"dismiss MCBrowser");
    [_mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
     NSLog(@"dismiss MCBrowser");
    [_mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


/********** ALERT BLUETOOTH IF NOT ON ********/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state==CBCentralManagerStatePoweredOff)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLUETOOTH IS SWITCHED OFF SO UNABLE TO SCAN FOR DEVICES" message:nil delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      [_mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/************** open browse for devices and connect to the devices ***********/
- (IBAction)addContactAction:(id)sender {
    
    [_mcManager setupMCBrowser];
    _mcManager.browser.delegate = self;
    [self presentViewController:_mcManager.browser animated:YES completion:nil];
}


/************ remove all observers  ***********/
-(void)dealloc
{
    NSLog(@"removing observer call recieved and state of the Device");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
