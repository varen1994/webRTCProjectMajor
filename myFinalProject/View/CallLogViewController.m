//
//  CallLogViewController.m
//  myFinalProject
//
//  Created by Varender on 4/28/16.
//  Copyright © 2016 Addval. All rights reserved.
//

#import "CallLogViewController.h"
#import "CallLogTableViewCell.h"

@interface CallLogViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *array;
}
@end

@implementation CallLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.callLogTableView.dataSource = self;
    self.callLogTableView.delegate = self;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    array = [[NSMutableArray alloc]init];
    array = [NSMutableArray arrayWithArray:[def objectForKey:@"CallLogs"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    array = [[NSMutableArray alloc]init];
    array = [NSMutableArray arrayWithArray:[def objectForKey:@"CallLogs"]];
    [_callLogTableView reloadData];
}



#pragma mark Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallLogTableViewCell *cell = (CallLogTableViewCell *)[_callLogTableView dequeueReusableCellWithIdentifier:@"callLogCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dic = array[[array count]-indexPath.row-1];
    cell.labelName.text = [dic valueForKey:@"Name"];
    cell.labelTime.text = [dic valueForKey:@"Time"];
    cell.labelDate.text = [dic valueForKey:@"Date"];
    cell.labelType.text = [dic valueForKey:@"Type"];
    if([[dic valueForKey:@"Type"] isEqualToString:@"missed call"] )
    {
        cell.labelType.textColor = [UIColor redColor];
    }
    if([[dic valueForKey:@"Type" ] isEqualToString:@"outgoing call"])
    {
        cell.labelType.textColor = [UIColor greenColor];
    }
    if([[dic valueForKey:@"Type" ] isEqualToString:@"incoming call"])
    {
        cell.labelType.textColor = [UIColor blueColor];
    }
    
    NSLog(@"%@",dic);
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [array removeObjectAtIndex:[array count]-indexPath.row-1];
        [_callLogTableView reloadData];
        NSLog(@"%@",array);
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:array forKey:@"CallLogs"];
    [def synchronize];
}
@end
