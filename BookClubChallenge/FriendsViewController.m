//
//  ViewController.m
//  BookClubChallenge
//
//  Created by Justin Haar on 4/1/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "FriendsViewController.h"
#import "PeopleViewController.h"
#import "ProfileViewController.h"
#import "Friend.h"
#import "AppDelegate.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSMutableArray *friends;
@property (nonatomic)  NSMutableArray *filteredFriends;
@property NSMutableArray *sortedFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property Friend *friend;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    self.moc = [appdelegate managedObjectContext];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFriends];
}


-(void)loadFriends
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    self.friends = [[self.moc executeFetchRequest:request error:nil]mutableCopy];
    self.filteredFriends = [self.friends mutableCopy];
    [self.tableView reloadData];
}


//-(void)loadWithPredicateFormat:(NSSet *)set
//{
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"books.@count" ascending:YES];
//    self.sortedFriends = [self.friends sortedArrayUsingDescriptors:@[sortDescriptor]].mutableCopy;
//    self.filteredFriends = self.sortedFriends;
//    [self.tableView reloadData];
//}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    self.friend = self.filteredFriends[indexPath.row];
    cell.textLabel.text = self.friend.name;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredFriends.count;
}

//need to ask about this
-(void)setFilteredFriends:(NSMutableArray *)filteredFriends
{
    _filteredFriends = filteredFriends;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Profile"])
    {
        ProfileViewController *profileVC = segue.destinationViewController;
        //this allows us to distinguish between which cell we are clicking.
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.friend = [self.friends objectAtIndex:indexPath.row];
        profileVC.friend = self.friend;
        profileVC.moc = self.moc;
    } else
    {
        PeopleViewController *peopleVC = segue.destinationViewController;
        peopleVC.friends = self.friends;
    }

}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        //mutable copy gives us a mutable copy of the filtered array
        self.filteredFriends = [self.friends mutableCopy];
    } else
    {
        [self.filteredFriends removeAllObjects];
        for (Friend *friend in self.friends)
        {
            NSRange nameRange = [friend.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound)
            {
                [self.filteredFriends addObject:friend];
            }
        }
    }
    [self.tableView reloadData];
}


@end
