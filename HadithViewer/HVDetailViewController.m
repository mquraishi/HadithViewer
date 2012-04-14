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

@synthesize detail = _detail;
@synthesize detailDescription = _detailDescription;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize hBookNumber = _hBookNumber;
@synthesize hNumber = _hNumber;

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
    [downArrow setFrame:CGRectMake(305, 395, 18, 18)];
    self.detailDescriptionLabel.delegate=self;
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Book %d - Hadith #%d", _hBookNumber, _hNumber]];
    
    UIImage *pattern = [UIImage imageNamed:@"databgrnd.jpg"];
    
    // Set the image as a background pattern
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton.tintColor = [UIColor blackColor];
    // use existing instantiated view inside view controller;
    // ensure autosizing enabled
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDetailDescription:nil];
    [self setDetailDescription:nil];
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
@end
