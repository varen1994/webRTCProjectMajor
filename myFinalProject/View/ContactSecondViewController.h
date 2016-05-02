//
//  ContactSecondViewController.h
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MCManager.h"

@interface ContactSecondViewController : UIViewController
@property (strong,nonatomic) CBCentralManager *cbManager;
- (IBAction)addContactAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *contactTableView;
@property (strong, nonatomic) IBOutlet UIView *viewOverTable;

@property (strong,nonatomic) MCManager *mcManager;
-(void) peerDidChangeExistingState:(NSNotification *)notification;
-(void)callReceived: (NSNotification *)notification;


@end
