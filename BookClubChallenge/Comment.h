//
//  Comment.h
//  BookClubChallenge
//
//  Created by Justin Haar on 4/1/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Friend;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) Friend *friend;

@end
