//
//  ProfileViewController.h
//  BookClubChallenge
//
//  Created by Justin Haar on 4/5/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface ProfileViewController : UIViewController

@property Friend *friend;
@property NSManagedObjectContext *moc;

@end
