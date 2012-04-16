//
//  HVDetailViewController.m
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HVDetailViewController.h"
#import "Hadith.h"

@interface HVDetailViewController ()
- (void)configureView;
@end

@implementation HVDetailViewController
@synthesize sendHadith;
@synthesize detail = _detail;
@synthesize detailDescription = _detailDescription;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize hBookNumber = _hBookNumber;
@synthesize hNumber = _hNumber;
@synthesize firstName, lastName, email, phoneNumber, peoplePicker, smsSelected, emailSelected;

void (^showAlertWithTitlesAndMsg)(id, NSString *, NSString *, NSString *) = ^(id obj, NSString *title, NSString *message, NSString *buttonTitle) 
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:title 
                          message:message
                          delegate:obj 
                          cancelButtonTitle:buttonTitle
                          otherButtonTitles: nil];
    [alert show];
};

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detail != newDetailItem) {
        _detail = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detail) {
        // Add to the view controller
        [self.detailDescription addSubview:upArrow];
        [self.detailDescription addSubview:downArrow];

        NSMutableArray *hData = (NSMutableArray *)self.detail;
        
        for (Hadith *hadith in hData ) {
            NSString *hStr = [NSString stringWithFormat:@"%@\n",hadith.hadith];
            self.detailDescriptionLabel.text = [NSString stringWithFormat:@"\n%@\n", hStr];
                    [self.detailDescription addSubview:self.detailDescriptionLabel];
        }
    }
}

/*---------------------------------------------------------------------------
 * Adjust arrows indicating more content
 *--------------------------------------------------------------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Are we at the bottom of the scrollview ?
    if (scrollView.contentOffset.y < 
        scrollView.contentSize.height - scrollView.frame.size.height)
        downArrow.hidden = NO;
    else
        downArrow.hidden = YES;
    
    // Are we at the top of the scrollview ?
    if (scrollView.contentOffset.y > 0)
        upArrow.hidden = NO;
    else
        upArrow.hidden = YES;  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Arrows to indicate more content
    upArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up.png"]];
    downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"]];   
    
    // Upon startup, we are at the top...
    // no content up, more content down
    upArrow.hidden = YES;
    downArrow.hidden = NO;
    
    // Set the frame
    [upArrow setFrame:CGRectMake(305, 0, 18, 18)];
    [downArrow setFrame:CGRectMake(305, 350, 18, 18)];
    self.detailDescriptionLabel.delegate=self;
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Book %d - Hadith #%d", _hBookNumber, _hNumber]];
    
    UIImage *pattern = [UIImage imageNamed:@"databgrnd.jpg"];
    
    // Set the image as a background pattern
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton.tintColor = [UIColor blackColor];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];    
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    // use existing instantiated view inside view controller;
    // ensure autosizing enabled
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
    self.sendHadith.delegate = self;
    self.smsSelected = false;
    self.emailSelected = false;
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDetailDescription:nil];
    [self setDetailDescription:nil];
    [self setSendHadith:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
*/


#pragma mark Show all contacts
// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email.
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
    
    self.peoplePicker = picker;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    self.firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty); 
    self.lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
   
    
    if ((self.firstName.length == 0) && (self.lastName.length > 0)) {
        self.firstName = @"";
    } else if ((self.firstName.length > 0) && (self.lastName.length == 0)) {
        self.lastName = @"";
    } else if ((self.firstName.length == 0) && (self.lastName.length == 0)) {
        self.lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        self.lastName  = self.lastName.length  == 0 ? @"No Name Found" : self.lastName;
        self.firstName = @"";
    } 
    
	return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonEmailProperty) {
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        if (ABMultiValueGetCount(emails) > 0) {
            self.email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, identifier);
        } else {
            self.email = @""; 
        }
    } else if (property == kABPersonPhoneProperty) {
        ABMultiValueRef pnums = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(pnums) > 0) {
            self.phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(pnums, identifier);
        } else {
            self.phoneNumber = @"";
        }
    }
    if (self.emailSelected) {
        [self showEmailModalView];
    } else if (self.smsSelected) {
        [self showSMSModalView];
    }

	return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}



#pragma Email and SMS modal code
//
//
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // Detect which item was clicked.  
    if ([[item title] isEqualToString:@"Send Email"]) {
        [self showPeoplePickerController];
        self.emailSelected = true;
        self.smsSelected = false;
        // Show the picker 
        [self presentModalViewController:self.peoplePicker animated:YES];
    } else if ([[item title] isEqualToString:@"Send Text"]) {
        [self showPeoplePickerController];
        self.smsSelected = true;
        self.emailSelected = false;
        // Show the picker 
        [self presentModalViewController:self.peoplePicker animated:YES];
    }
}


- (void)showEmailModalView {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        
        mailPicker.mailComposeDelegate = self;

        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:(self.email.length == 0 ? @"":self.email)]; 
        [mailPicker setToRecipients:toRecipients];
        [mailPicker setSubject:[NSString stringWithFormat:@"A Hadith just for you %@ %@", self.firstName, self.lastName]];
        // Fill out the email body text
        NSMutableArray *hData = (NSMutableArray *)self.detail;
        NSString *emailBody;
        for (Hadith *hadith in hData ) {
            emailBody = [NSString stringWithFormat:@"Volume: %@ \n Book: %@ \n Hadith #: %@ \n Narrated by: %@ \n Hadith: %@ \n",hadith.volume,hadith.book,hadith.number,hadith.narrated,hadith.hadith];
        }
        [mailPicker setMessageBody:emailBody isHTML:NO];
        mailPicker.navigationBar.barStyle = UIBarStyleBlack;
        [self.peoplePicker presentModalViewController:mailPicker animated:YES];
    } else {
        showAlertWithTitlesAndMsg(self, @"Email", @"Device not capable of sending emails.", @"OK");
       // [self.navigationController popViewControllerAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)showSMSModalView {
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        
        // Fill out the sms body
        NSMutableArray *hData = (NSMutableArray *)self.detail;
        for (Hadith *hadith in hData ) {
            picker.body = [NSString stringWithFormat:@"Volume: %@ \n Book: %@ \n Hadith #: %@ \n Narrated by: %@ \n Hadith: %@ \n",hadith.volume,hadith.book,hadith.number,hadith.narrated,hadith.hadith];
        }

        picker.recipients = [NSArray arrayWithObjects:(self.phoneNumber.length == 0 ? @"":self.phoneNumber),nil];
        picker.messageComposeDelegate = self;
        [self.peoplePicker presentModalViewController:picker animated:YES];
    } else {
        showAlertWithTitlesAndMsg(self, @"SMS", @"Device not capable of sending text messages.", @"OK");
        //[self.navigationController popViewControllerAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
        {
            showAlertWithTitlesAndMsg(self, @"Email", @"Sending Failed - Unknown Error", @"OK");
        }
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// Dismisses the SMS composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
			break;
		default:
        {
            showAlertWithTitlesAndMsg(self, @"SMS", @"Sending Failed - Unknown Error", @"OK");
        }
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
