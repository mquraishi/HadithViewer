//
//  HVSecondViewController.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HVSecondViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *detail;
@property (nonatomic) int displayVolume;
@property (nonatomic) int displayBook;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
