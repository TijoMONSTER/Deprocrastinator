//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Iván Mervich on 7/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *todoList;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.todoList = [NSArray arrayWithObjects:
                     @"Get my bike!",
                     @"Feed the dog!",
                     @"Say hi to my parents",
                     @"Run Forest, ruuuuun!",
                     nil];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [self.todoList objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.todoList count];
}

@end
