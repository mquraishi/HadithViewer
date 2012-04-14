//
//  HVViewController.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/27/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVViewController : UIViewController  <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableDictionary *bookNames;
@property NSInteger volumeNumber;

- (IBAction)buttonViewByBook:(id)sender;


@end
