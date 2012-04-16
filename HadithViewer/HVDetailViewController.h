//
//  HVDetailViewController.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HVDetailViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UITextViewDelegate, UITabBarDelegate,  MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIImageView *upArrow, *downArrow;
    NSString *firstName;
    NSString *lastName;
    NSString *phoneNumber;
    NSString *email;
    ABPeoplePickerNavigationController *peoplePicker;
    BOOL emailSelected;
    BOOL smsSelected;
}

@property (nonatomic) int hBookNumber;
@property (nonatomic) int hNumber;
@property (nonatomic) BOOL emailSelected;
@property (nonatomic) BOOL smsSelected;
@property (strong, nonatomic) NSMutableArray *detail;
@property (strong, nonatomic) IBOutlet UIScrollView *detailDescription;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionLabel;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) ABPeoplePickerNavigationController *peoplePicker;
@property (strong, nonatomic) IBOutlet UITabBar *sendHadith;

/*
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
*/

- (void) showEmailModalView;
- (void) showSMSModalView;
- (void) showPeoplePickerController;

@end
