//
//  HVSecondViewController.m
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HVSecondViewController.h"
#import "Hadith.h"
#import "HVDetailViewController.h"

@implementation HVSecondViewController

@synthesize detail = _detail;
@synthesize displayVolume = _displayVolume;
@synthesize displayBook = _displayBook;
@synthesize managedObjectContext;

#pragma mark - Managing the second level detail

- (void)setDetail:(NSMutableArray *)newDetail
{
    if (_detail != newDetail) {
        _detail = newDetail;
    }
}

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
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Volume %d - Book %d", self.displayVolume, self.displayBook]];
    backButton.tintColor = [UIColor blackColor];
    //UIImage *pattern = [UIImage imageNamed:@"bgrndNS.jpg"];
    
    // Set the image as a background pattern
    //[[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
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
        return [self.detail count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Hadith *hData = [[self detail] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Hadith #%d",hData.number.intValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Narrated by %@",hData.narrated];
    cell.textLabel.tag = hData.number.integerValue;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        Hadith *hData = [[self detail] objectAtIndex:indexPath.row];
        
        NSMutableArray *hD = [Hadith hadithTextForHadithNumber:cell.textLabel.tag andBookNum:hData.book inManagedObjectContext:self.managedObjectContext];

        [[segue destinationViewController] setDetail:hD];
        [[segue destinationViewController] setHBookNumber:hData.book.intValue];
        [[segue destinationViewController] setHNumber:cell.textLabel.tag];
    }
}   


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end
