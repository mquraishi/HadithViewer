//
//  HVMasterViewController.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HVMasterViewController : UITableViewController {
    NSArray *sortedKeys;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableDictionary *bookNames;

@end
