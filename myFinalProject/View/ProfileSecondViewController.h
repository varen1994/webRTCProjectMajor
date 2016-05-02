//
//  ProfileSecondViewController.h
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveNameProtocol <NSObject>
@required
-(void)methodToSaveData:(NSString *)name;

@end



@interface ProfileSecondViewController : UIViewController
@property (strong,nonatomic) NSString *nameAlreadyPresent;
@property (strong, nonatomic) IBOutlet UIButton *saveButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
@property (strong, nonatomic) IBOutlet UITextField *textNameProfileSecond;
@property (weak,nonatomic) id <SaveNameProtocol> delegate;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;


@end
