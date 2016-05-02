//
//  ProfileViewController.m
//  myFinalProject
//
//  Created by Varender on 4/11/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileSecondViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ProfileViewController ()<UITextFieldDelegate , SaveNameProtocol ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.editButtonOutlet.layer.cornerRadius = 4;
    self.imageButtonOutlet.layer.cornerRadius = 5;
    self.imageButtonOutlet.layer.borderWidth = 1;
    self.imageButtonOutlet.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textName setEnabled:NO];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *nameArray = [defs objectForKey:@"NameOfTheUser"];
    NSString *nameString = nameArray[0];
    if(nameString.length!=0)
    {
        self.textName.text = nameString;
    }
    
    NSUserDefaults *def2 = [NSUserDefaults standardUserDefaults];
    NSData *data = [def2 objectForKey:@"MyProfileImage"];
    if(data!=nil)
    {
        [self.imageButtonOutlet setBackgroundImage:[UIImage imageWithData:data] forState:0];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"profileImage.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSUserDefaults *def2 = [NSUserDefaults standardUserDefaults];
        [def2 setObject:data forKey:@"MyProfileImage"];
        [def2 synchronize];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textName resignFirstResponder];
    return YES;
}

-(void)methodToSaveData:(NSString *)name
{
    self.textName.text  = name;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfileSecondViewController *profileSecondViewController = (ProfileSecondViewController *)segue.destinationViewController;
    profileSecondViewController.nameAlreadyPresent = self.textName.text;
    profileSecondViewController.delegate = self;
}

- (IBAction)imageButtonAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Image" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Take Image",@"Pick From Gallery",@"Set as default",nil];
    alertView.alertViewStyle = UIAlertControllerStyleActionSheet;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(buttonIndex==1 || buttonIndex==2)
    {
       imagePicker = [[UIImagePickerController alloc]init];
       imagePicker.delegate = self;
           if(buttonIndex==1)  {
             imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
           }
          if(buttonIndex==2) {
              imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          }
       [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(buttonIndex==3)
    {
        UIImage *image = [UIImage imageNamed:@"profileImage.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSUserDefaults *def2 = [NSUserDefaults standardUserDefaults];
        [def2 setObject:data forKey:@"MyProfileImage"];
        [def2 synchronize];
        [self.imageButtonOutlet setBackgroundImage:[UIImage imageNamed:@"profileImage.jpg"] forState:0];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageButtonOutlet setBackgroundImage:image forState:UIControlStateNormal];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSUserDefaults *def2 = [NSUserDefaults standardUserDefaults];
    [def2 setObject:data forKey:@"MyProfileImage"];
    [def2 synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
