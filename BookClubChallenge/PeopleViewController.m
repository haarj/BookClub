//
//  PeopleViewController.m
//  BookClubChallenge
//
//  Created by Justin Haar on 4/1/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "PeopleViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Friend.h"

@interface PeopleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *people;
@property NSManagedObjectContext *moc;
@property Friend *aFriend;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"People";

    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    self.moc = [appdelegate managedObjectContext];

    self.people = [NSArray new];


    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (![userDefaults objectForKey:@"randomkey"])
    {
        [Person downloadPeopleWithCompletion:^(NSArray *peopleArray)
        {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSString *string in peopleArray)
            {
                Person *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.moc];
                person.name = string;
                [tempArray addObject:person];
            }
            self.people = tempArray.copy;
            [self.moc save:nil];
            [userDefaults setObject:@YES forKey:@"randomkey"];
            [userDefaults synchronize];
            [self.tableView reloadData];
        }];
    }else
    {
        [self loadData];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

-(void)loadData
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
    self.people = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [[self.people objectAtIndex:indexPath.row]name];
    Person *person = [self.people objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (Friend *friend in self.friends) {
        if ([friend.name isEqualToString:person.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.people.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        Friend *friend = self.people[indexPath.row];
        friend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Friend class]) inManagedObjectContext:self.moc];
        friend.name = [self.people[indexPath.row]name];
        [self.friends addObject:friend];
        [self.moc save:nil];
    } else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        Person *person = self.people[indexPath.row];
        for (int i = 0; i < self.friends.count; i++)
        {
            Friend *friend = self.friends[i];
            if ([friend.name isEqual:person.name])
            {
                [self.moc deleteObject:friend];
                [self.friends removeObject:friend];
                [self.moc save:nil];
            }
        }
    }
}

@end
