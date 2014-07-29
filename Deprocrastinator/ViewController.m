//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Iván Mervich on 7/28/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL isEditing;
@property NSMutableArray *todoList;
@property NSMutableArray *todoListBackgroundColors;
@property NSMutableArray *todoListTextColors;

@property NSIndexPath *indexPathToDelete;
@property BOOL deletionByClickingOnDeleteButton;

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
    
    self.todoListBackgroundColors = [[NSMutableArray alloc] initWithObjects:
                           [UIColor whiteColor],
                           [UIColor whiteColor],
                           [UIColor whiteColor],
                           [UIColor whiteColor],
                           nil];

    self.todoListTextColors = [[NSMutableArray alloc] initWithObjects:
                           [UIColor blackColor],
                           [UIColor blackColor],
                           [UIColor blackColor],
                           [UIColor blackColor],
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
    cell.textLabel.textColor = [self.todoListTextColors objectAtIndex:indexPath.row];
    cell.backgroundColor = [self.todoListBackgroundColors objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.todoList count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // clicked on the delete button
    self.deletionByClickingOnDeleteButton = YES;
    self.indexPathToDelete = indexPath;
    [self showDeletionConfirmationAlertView];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *todoActivity = [self.todoList objectAtIndex:sourceIndexPath.row];
    UIColor *todoActivityBackgroundColor = [self.todoListBackgroundColors objectAtIndex:sourceIndexPath.row];
    UIColor *todoActivityTextColor = [self.todoListTextColors objectAtIndex:sourceIndexPath.row];

    [self removeObjectFromTodoListAndTodoColorListAtIndex:sourceIndexPath.row];
    
    [self.todoList insertObject:todoActivity atIndex:destinationIndexPath.row];
    [self.todoListBackgroundColors insertObject:todoActivityBackgroundColor atIndex:destinationIndexPath.row];
    [self.todoListTextColors insertObject:todoActivityTextColor atIndex:destinationIndexPath.row];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    // clicked on the cell, change its color or remove the item

    if (self.isEditing) {
        self.deletionByClickingOnDeleteButton = NO;
        self.indexPathToDelete = indexPath;
        [self showDeletionConfirmationAlertView];
    }
    else {
        cell.textLabel.textColor = [UIColor greenColor];
        [self.todoListTextColors setObject:cell.textLabel.textColor atIndexedSubscript:indexPath.row];
//        [self.todoListBackgroundColors setObject:cell.backgroundColor atIndexedSubscript:indexPath.row];
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
        [self.todoListBackgroundColors addObject:[UIColor whiteColor]];
        [self.todoListTextColors addObject:[UIColor blackColor]];
        [self.tableView reloadData];

        // reset textfield
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
    // find the cell that was tapped
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

        // if the cell exists and it has text, change its text color
        if (cell && [cell.textLabel.text length] > 0) {
            [self setCellTextLabelPriorityColor:cell];
            
            // save the color in the array
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self.todoListBackgroundColors setObject:cell.backgroundColor atIndexedSubscript:cellIndexPath.row];
            
        }
    }
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // clicked on alert's delete button
    if (buttonIndex == 0) {
        // remove item from the array
        [self removeObjectFromTodoListAndTodoColorListAtIndex:self.indexPathToDelete.row];
        
        // clicked on cell's delete button
        if (self.deletionByClickingOnDeleteButton) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        // clicked on cell in editing mode
        else {
            [self.tableView reloadData];
        }
    }

    self.deletionByClickingOnDeleteButton = NO;
    self.indexPathToDelete = nil;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onAddButtonPressed:nil];
    return YES;
}

#pragma mark Helper methods

- (void)showDeletionConfirmationAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = @"Alert";
    alertView.message = @"Are you sure you want to delete this item?";
    alertView.delegate = self;

    [alertView addButtonWithTitle:@"Delete"];
    [alertView addButtonWithTitle:@"Cancel"];
    [alertView show];
}

- (void)setCellTextLabelPriorityColor:(UITableViewCell *)cell
{
    UIColor *color = cell.backgroundColor;

    // set high priority
    if ([color isEqual:[UIColor whiteColor]] || [color isEqual:[UIColor greenColor]]) {
        color = [UIColor redColor];
    }
    // set medium priority
    else if ([color isEqual:[UIColor redColor]]) {
        color = [UIColor yellowColor];
    }
    // set low priority
    else if ([color isEqual:[UIColor yellowColor]]) {
        color = [UIColor greenColor];
    }

    cell.backgroundColor = color;
}

- (void)removeObjectFromTodoListAndTodoColorListAtIndex:(NSUInteger)index
{
    [self.todoList removeObjectAtIndex:index];
    [self.todoListBackgroundColors removeObjectAtIndex:index];
    [self.todoListTextColors removeObjectAtIndex:index];
}

@end
