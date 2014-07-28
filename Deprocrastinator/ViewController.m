//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Iván Mervich on 7/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *addItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL isEditing;

@property  NSMutableArray *todoList;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.todoList = [[NSMutableArray alloc] initWithObjects:
                     @"Get my bike!",
                     @"Feed the dog!",
                     @"Say hi to my parents",
                     @"Run Forest, ruuuuun!",
                     nil];

    self.isEditing = NO;
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

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.isEditing) {
        [self.todoList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    else {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

#pragma mark IBActions

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    // if the textfield is not empty
    if ([self.addItemTextField.text length] > 0) {
        [self.todoList addObject:self.addItemTextField.text];
        [self.tableView reloadData];

        self.addItemTextField.text = @"";
        [self.addItemTextField resignFirstResponder];
    }
}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{
    // toggle text
    if (!self.isEditing) {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
    else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }

    self.isEditing = !self.isEditing;
}

@end
