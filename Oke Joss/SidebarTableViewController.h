//
//  SidebarTableViewController.h
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface SidebarTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSMutableArray *subMenu;
@property (strong, nonatomic) NSCache *cacheMenu;

- (BOOL) connected;

@end
