//
//  AboutViewController.m
//  Oke Joss
//
//  Created by Andi Baskoro on 2/2/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.about.text = @"OkeJoss.com merupakan media online di Indonesia yang bertujuan untuk memberikan informasi dan berita terbaru kepada seluruh pengguna online di Indonesia. OkeJoss.com akan senantiasa memberikan update informasi dan berita secara cepat, tepat dan oke bagi seluruh pengguna internet menggunakan berbagai teknologi digital yang ada saat ini. \n\nPilahan Asri No 40 Yogyakarta 55171 \nEmail : redaksi@okejoss.com \nMarketing & Iklan: atanasia@okejoss.com";
    
    self.about.textAlignment = NSTextAlignmentJustified;
    
    CGRect frame = _about.frame;
    frame.size.height = [_about sizeThatFits:CGSizeMake(_about.frame.size.width, MAXFLOAT)].height;
    _about.frame = frame;
    [self.about sizeToFit];
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.content.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [self.scrollView setContentSize:(CGSizeMake(self.content.frame.size.width, scrollViewHeight))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    CGRect frame = _about.frame;
    frame.size.height = [_about sizeThatFits:CGSizeMake(_about.frame.size.width, MAXFLOAT)].height;
    _about.frame = frame;
    [self.about sizeToFit];
}

- (void) viewDidLayoutSubviews{
    //[self.content setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.content.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [self.scrollView setContentSize:(CGSizeMake(self.content.frame.size.width, scrollViewHeight))];
}

@end
