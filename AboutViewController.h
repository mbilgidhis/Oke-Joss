//
//  AboutViewController.h
//  Oke Joss
//
//  Created by Andi Baskoro on 2/2/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *about;
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)close;

@end
