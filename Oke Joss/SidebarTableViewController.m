//
//  SidebarTableViewController.m
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import "KategoriTableViewController.h"
#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "AboutViewController.h"

@interface SidebarTableViewController ()

@property (strong, nonatomic) NSString *sidebarKategori;

@end

@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSUserDefaults *menu = [NSUserDefaults standardUserDefaults];
    
    if (![self connected]) {
        
        if (![menu objectForKey:@"menu"]) {
            UIAlertView *notConnected = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Tidak Ada Koneksi Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            
            [notConnected show];
        }
        
    }else{
    
        NSString *apiId = @"okjapi";
        NSString *apiToken = @"843nthkm4k";
    
        NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@", apiId, apiToken];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://ok.ptjdev.com/api/category/"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
        NSURLResponse *response;
        NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
        NSArray *data = [theReply objectForKey:@"data"];
        self.menu = [data copy];
    
        self.subMenu = [[NSMutableArray alloc] init];
    
        NSArray *tempMenu = [[NSArray alloc] init];
        NSArray *tempSubMenu = [[NSArray alloc] init];

        for (int x = 0; x < [self.menu count]; x++){
            tempMenu = [self.menu objectAtIndex:x];
            [self.subMenu addObject:tempMenu];
            if ( [[[self.menu objectAtIndex:x] objectForKey:@"sub"] count] > 0){
                tempSubMenu = [[self.menu objectAtIndex:x] objectForKey:@"sub"];
                for (int y = 0 ; y < [tempSubMenu count]; y++){
                    NSArray *subMenu = [[NSArray alloc] init];
                    subMenu = [tempSubMenu objectAtIndex:y];
                    [self.subMenu addObject:subMenu];
                }
            }
        }
        NSDictionary *about = [[NSDictionary alloc] initWithObjectsAndKeys:@"about",@"id",@"About",@"title", nil];
    
        [self.subMenu addObject:about];
        
        if (![menu objectForKey:@"menu"]) {
            [menu setObject:self.subMenu forKey:@"menu"];
            [menu synchronize];
        }else{
            [menu removeObjectForKey:@"menu"];
            [menu setObject:self.subMenu forKey:@"menu"];
            [menu synchronize];
        }
        //[menu setObject:self.subMenu forKey:@"menu"];
        //[menu synchronize];
        //NSLog(@"%@", [menu objectForKey:@"menu"]);
        //NSLog(@"%@", self.subMenu);
    }

}

- (BOOL)connected{
    Reachability *internet = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internet currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //if ([self connected]) {
    //    return 1;
    //}else{
    //    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    //    messageLabel.text = @"";
    //    self.tableView.backgroundView = messageLabel;
   //     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   // }
   // return 0;
    NSUserDefaults *menu = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        return 1;
    }else{
        if ([menu objectForKey:@"menu"]) {
            return 1;
        } else{
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"";
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.subMenu count];
    NSUserDefaults *menu = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        return [self.subMenu count];
    }else{
        if ([menu objectForKey:@"menu"]) {
            return [[menu objectForKey:@"menu"] count];
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUserDefaults *menu = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictMenu = [[NSDictionary alloc] init];
    if ([self connected]) {
        dictMenu = [self.subMenu objectAtIndex:[indexPath row]];
    }else{
        if ([menu objectForKey:@"menu"]) {
            dictMenu = [[menu objectForKey:@"menu"] objectAtIndex:[indexPath row]];
        }else{
            dictMenu = nil;
        }
    }
    
    //if ([menu objectForKey:@"menu"]){
    //    dictMenu = [[menu objectForKey:@"menu"] objectAtIndex:[indexPath row]];
    //}else{
    //    dictMenu = [self.subMenu objectAtIndex:[indexPath row]];
    //}
    
    if ([dictMenu objectForKey:@"sub"]){
        [cell setIndentationLevel:1];
    }else{
        if([[dictMenu objectForKey:@"id"] isEqualToString:@"about"]){
            [cell setIndentationLevel:1];
        }else{
            [cell setIndentationLevel:3];
        }
    }
    
    [cell.textLabel setText:[dictMenu objectForKey:@"title"]];
    
    //NSDictionary *menu = [self.subMenu objectAtIndex:[indexPath row]];
    
    //if ([menu objectForKey:@"sub"]){
    //    [cell setIndentationLevel:1];
    //}else{
    //    if([[menu objectForKey:@"id"] isEqualToString:@"about"]){
    //        [cell setIndentationLevel:1];
    //    }else{
    //        [cell setIndentationLevel:3];
    //    }
    //}
    
    //[cell.textLabel setText:[menu objectForKey:@"title"]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"push_to_view_category"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        KategoriTableViewController *controller = (KategoriTableViewController *)navController.topViewController;
        //controller.title = [self.sidebarKategori capitalizedString];
        [controller setKategori:self.sidebarKategori];
    }else{
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AboutViewController *controller = (AboutViewController *)navController.topViewController;
        [controller setTitle:@"About Oke Joss"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *kategori = [[NSDictionary alloc]init];
    NSUserDefaults *listKategori = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        kategori = [self.subMenu objectAtIndex:[indexPath row]];
    }else{
        if ([listKategori objectForKey:@"menu"]) {
            kategori = [[listKategori objectForKey:@"menu"] objectAtIndex:[indexPath row]];
        }
    }
    
    //NSDictionary *kategori = [self.subMenu objectAtIndex:[indexPath row]];
    self.sidebarKategori = [kategori objectForKey:@"id"];
    //NSLog(@"%@", self.kategori);
    
    
    //Perform Segue
    if ([self.sidebarKategori isEqualToString:@"about"]){
        [self performSegueWithIdentifier:@"show_about" sender:self];
    }else{
        [self performSegueWithIdentifier:@"push_to_view_category" sender:self];
    }
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
