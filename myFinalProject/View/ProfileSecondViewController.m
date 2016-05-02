//
//  ProfileSecondViewController.m
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "ProfileSecondViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileSecondViewController ()<UITextFieldDelegate>

@end

@implementation ProfileSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButtonOutlet.layer.cornerRadius = 20;
    self.cancelButtonOutlet.layer.cornerRadius = 20;
    self.textNameProfileSecond.text = self.nameAlreadyPresent;
    [self.textNameProfileSecond becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textNameProfileSecond resignFirstResponder];
    return YES;
}


- (IBAction)saveButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(methodToSaveData:)])
    {
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        [defs setObject:@[self.textNameProfileSecond.text] forKey:@"NameOfTheUser"];
        [defs synchronize];
        [self.delegate methodToSaveData:self.textNameProfileSecond.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
