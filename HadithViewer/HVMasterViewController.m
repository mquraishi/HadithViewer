//
//  HVMasterViewController.m
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HVMasterViewController.h"
#import "Hadith.h"
#import "HVSecondViewController.h"

@implementation HVMasterViewController

@synthesize managedObjectContext;
@synthesize bookNames = _bookNames;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton.tintColor = [UIColor blackColor];
    
    UIImage *pattern = [UIImage imageNamed:@"bgrndNS.jpg"];
    
    // Set the image as a background pattern
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
    
    sortedKeys = [Hadith returnSortedArrayOfKeys:self.bookNames];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bookNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"]; 
    NSString *labelStr = [sortedKeys objectAtIndex:(indexPath.row)];
    cell.textLabel.text = [[self bookNames] valueForKey:labelStr];
    cell.textLabel.tag = [labelStr integerValue];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSecondLevel"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableArray *hData = [Hadith hadithDataForBookNum:[NSNumber numberWithInteger:cell.textLabel.tag] inManagedObjectContext:self.managedObjectContext];

        Hadith *hd = [hData objectAtIndex:0];

        [[segue destinationViewController] setDetail:hData];
        [[segue destinationViewController] setDisplayVolume:hd.volume.intValue];
        [[segue destinationViewController] setDisplayBook:hd.book.intValue];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}   

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
