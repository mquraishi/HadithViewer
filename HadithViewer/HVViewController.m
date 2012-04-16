//
//  HVViewController.m
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/27/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HVViewController.h"

#import "Hadith.h"

@interface HVViewController ()

@end

@implementation HVViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize bookNames = _bookNames;
@synthesize volumeNumber = _volumeNumber;


-(id)init
{
    if (self = [super init])
    {
        // Create image from the desired pattern (jpg or png)
        UIImage *pattern = [UIImage imageNamed:@"bgrnd.jpg"];
        
        // Set the image as a background pattern
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
    }
    return self;
}

// When the button viewByBook is pressed, push the next view
- (IBAction)buttonViewByBook:(id)sender
{
    self.volumeNumber = [(UIButton *)sender tag];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewByV1"] || 
        [[segue identifier] isEqualToString:@"viewByV2"] || 
        [[segue identifier] isEqualToString:@"viewByV3"] || 
        [[segue identifier] isEqualToString:@"viewByV4"] || 
        [[segue identifier] isEqualToString:@"viewByV5"] || 
        [[segue identifier] isEqualToString:@"viewByV6"] || 
        [[segue identifier] isEqualToString:@"viewByV7"] || 
        [[segue identifier] isEqualToString:@"viewByV8"] || 
        [[segue identifier] isEqualToString:@"viewByV9"]) {
        NSMutableDictionary * names = [Hadith bookNames:self.volumeNumber inManagedObjectContext:self.managedObjectContext];
        [[segue destinationViewController] setBookNames:names];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
