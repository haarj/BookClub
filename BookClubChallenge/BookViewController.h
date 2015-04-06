//
//  BookViewController.h
//  BookClubChallenge
//
//  Created by Justin Haar on 4/5/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "Book.h"

@interface BookViewController : UIViewController

@property Friend *friend;
@property Book *book;
@property NSManagedObjectContext *moc;


@end
