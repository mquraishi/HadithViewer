//
//  HVDetailViewController.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVDetailViewController : UIViewController <UITextViewDelegate>
{
    UIImageView *upArrow, *downArrow;
}

@property (nonatomic) int hBookNumber;
@property (nonatomic) int hNumber;
@property (strong, nonatomic) NSMutableArray *detail;
@property (strong, nonatomic) IBOutlet UIScrollView *detailDescription;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionLabel;
/*
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
*/
@end
