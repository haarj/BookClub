//
//  ProfileViewController.m
//  BookClubChallenge
//
//  Created by Justin Haar on 4/5/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "Book.h"
#import "BookViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property Book *book;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *books;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.friend.name;

    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    self.moc = [appdelegate managedObjectContext];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadBooks];
}


-(void)loadBooks
{
    //this loads books for each user
    self.books = [self.friend.books allObjects].mutableCopy;
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    self.book = self.books[indexPath.row];
    cell.textLabel.text = self.book.name;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (IBAction)onAddButtonTapped:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Book" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Book Name Here";
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.moc];
        UITextField *textField = alertController.textFields.firstObject;
        newBook.name = textField.text;
        [self.friend addBooksObject:newBook];
        [self.moc save:nil];
        [self loadBooks];
    }];

    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
        nil;
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BookViewController *bookVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.book = [self.books objectAtIndex:indexPath.row];
    bookVC.friend = self.friend;
    bookVC.book = self.book;
    bookVC.moc = self.moc;
}


@end
