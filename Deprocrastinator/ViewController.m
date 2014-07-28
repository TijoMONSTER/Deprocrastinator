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
    // allow cells to be selected during editing mode
    self.tableView.allowsSelectionDuringEditing = YES;

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove from the array and the tableView
    [self.todoList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *todoActivity = [self.todoList objectAtIndex:sourceIndexPath.row];

    [self.todoList removeObjectAtIndex:sourceIndexPath.row];
    [self.todoList insertObject:todoActivity atIndex:destinationIndexPath.row];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.isEditing) {
        [self.todoList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    else {
        cell.textLabel.textColor = [UIColor greenColor];
    }

    // deselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        [self.tableView setEditing:YES animated:YES];
    }
    else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }

    self.isEditing = !self.isEditing;
}

#pragma mark Gesture Recognizer

- (IBAction)onSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    // find the cell that was
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

        // if the cell exists and it has text, change its text color
        if (cell && [cell.textLabel.text length] > 0) {
            [self setCellTextLabelPriorityColor:cell];
        }
    }
}

#pragma mark Helper methods


- (void)setCellTextLabelPriorityColor:(UITableViewCell *)cell
{
    UIColor *color = cell.textLabel.textColor;

    // set high priority
    if (color == [UIColor blackColor] || color == [UIColor greenColor]) {
        color = [UIColor redColor];
    }
    // set medium priority
    else if (color == [UIColor redColor]) {
        color = [UIColor yellowColor];
    }
    // set low priority
    else if (color == [UIColor yellowColor]) {
        color = [UIColor greenColor];
    }

    cell.textLabel.textColor = color;
}

@end
