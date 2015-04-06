//
//  BookViewController.m
//  BookClubChallenge
//
//  Created by Justin Haar on 4/5/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "BookViewController.h"
#import "AppDelegate.h"
#import "Comment.h"

@interface BookViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Comment *comment;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@'s %@", self.friend.name, self.book.name];

    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    self.moc = [appdelegate managedObjectContext];

}


-(void)viewWillAppear:(BOOL)animated
{
    [self loadComments];
}


-(void)loadComments
{
    self.comments = [self.book.comments allObjects].mutableCopy;
    [self.tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    self.comment = self.comments[indexPath.row];
    cell.textLabel.text = self.comment.name;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (IBAction)onAddCommentTapped:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Comment" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Comment Here";
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        Comment *newComment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class]) inManagedObjectContext:self.moc];
        UITextField *textField = alertController.textFields.firstObject;
        newComment.name = textField.text;
        [self.book addCommentsObject:newComment];
        [self.moc save:nil];
        [self loadComments];
    }];

    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
        nil;
    }];
}





@end
