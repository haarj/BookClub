//
//  Person.m
//  BookClubChallenge
//
//  Created by Justin Haar on 4/5/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "Person.h"


@implementation Person

@dynamic name;

+(void)downloadPeopleWithCompletion:(void (^)(NSArray *))complete
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSArray *readersArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         complete(readersArray);
     }];
}

@end
