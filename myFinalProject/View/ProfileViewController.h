//
//  ProfileViewController.h
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UIButton *editButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *imageButtonOutlet;
- (IBAction)imageButtonAction:(id)sender;


@end
