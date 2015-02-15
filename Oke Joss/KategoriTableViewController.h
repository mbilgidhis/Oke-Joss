//
//  KategoriTableViewController.h
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface KategoriTableViewController : UITableViewController <UINavigationBarDelegate>

@property (nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) NSString *kategori;
@property (strong, nonatomic) NSMutableArray *listBerita;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *idBerita;

@property int page;

- (BOOL)connected;
@end
