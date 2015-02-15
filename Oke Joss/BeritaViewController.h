//
//  BeritaViewController.h
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface BeritaViewController : UIViewController

@property (strong, nonatomic) NSString *idBeritaView;
@property (strong, nonatomic) NSDictionary *isiBerita;

@property (strong, nonatomic) IBOutlet UIImageView *gambar;
//@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) IBOutlet UILabel *judul;
@property (strong, nonatomic) IBOutlet UITextView *tulisan;
@property (strong, nonatomic) IBOutlet UIScrollView *content;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *tanggal;

- (BOOL) connected;

@end
