//
//  MainTableViewController.m
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import "MainTableViewController.h"
#import "SWRevealViewController.h"
#import "beritaListTableViewCell.h"
#import "bigCellTableViewCell.h"
#import "BeritaViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Oke Joss";
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    
    if (![self connected]) {
        if (![mainNews objectForKey:@"news"]) {
            UIAlertView *notConnected = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Tidak Ada Koneksi Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            
            [notConnected show];
        }else{
            UIAlertView *offlineMode = [[UIAlertView alloc] initWithTitle:@"Offline Mode" message:@"Anda berada pada offline mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           
            [offlineMode show];
        }
    }else{
        
        self.listBerita = [[NSMutableArray alloc] init];
        NSString *apiId = @"okjapi";
        NSString *apiToken = @"843nthkm4k";
    
        NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@", apiId, apiToken];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://ok.ptjdev.com/api/articlelist/"]];
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
    
        [self.listBerita addObjectsFromArray:data];
        //self.listBerita = [data copy];
        _page = 2;
        //NSLog(@"%@", self.listBerita);
        if ([mainNews objectForKey:@"news"]) {
            [mainNews removeObjectForKey:@"news"];
            [mainNews setObject:self.listBerita forKey:@"news"];
            [mainNews synchronize];
        }else{
            [mainNews setObject:self.listBerita forKey:@"news"];
            [mainNews synchronize];
        }
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
    NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        return 1;
    }else{
        if ([mainNews objectForKey:@"news"]) {
            return 1;
        }else{
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            messageLabel.text = @"Tidak ada koneksi internet";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [messageLabel sizeToFit];
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        return [self.listBerita count];
    }else{
        if ([mainNews objectForKey:@"news"]) {
            return [[mainNews objectForKey:@"news"] count];
        }else{
            return 0;
        }
    }
    //return [self.listBerita count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *listBeritaIdentifier = @"beritaList";
    NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        if (indexPath.row == 0){
            bigCellTableViewCell *cell = (bigCellTableViewCell*) [tableView dequeueReusableCellWithIdentifier:listBeritaIdentifier];
            if (cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"bigCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.judul.text = [[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            [cell.gambar sd_setImageWithURL:[NSURL URLWithString:[[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            return  cell;
        }else{
            beritaListTableViewCell *cell = (beritaListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:listBeritaIdentifier];
            if (cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"beritaList" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.judul.text = [[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.gambar sd_setImageWithURL:[[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"imageurl"]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            return  cell;
        }
    }else{
        if ([mainNews objectForKey:@"news"]) {
            if (indexPath.row == 0){
                bigCellTableViewCell *cell = (bigCellTableViewCell*) [tableView dequeueReusableCellWithIdentifier:listBeritaIdentifier];
                if (cell == nil){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"bigCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.judul.text = [[[mainNews objectForKey:@"news"] objectAtIndex:indexPath.row] objectForKey:@"title"];
                
                [cell.gambar sd_setImageWithURL:[NSURL URLWithString:[[[mainNews objectForKey:@"news"] objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                return  cell;
            }else{
                beritaListTableViewCell *cell = (beritaListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:listBeritaIdentifier];
                if (cell == nil){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"beritaList" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.judul.text = [[[mainNews objectForKey:@"news"] objectAtIndex:indexPath.row] objectForKey:@"title"];
                [cell.gambar sd_setImageWithURL:[[[mainNews objectForKey:@"news"] objectAtIndex:indexPath.row] objectForKey:@"imageurl"]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                return  cell;
            }
        }else{
            return nil;
        }
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        // check if indexPath.row is last row
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        if (_page <= 5){
            if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
                
                [self loadMore:_page];
                _page +=1;
            }
        }
    }
    
}

- (void) loadMore:(NSInteger)page {
    //NSLog(@"%lu",page);
    NSString *apiId = @"okjapi";
    NSString *apiToken = @"843nthkm4k";
    //NSLog(@"%lu", page);
    NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@&page=%lu", apiId, apiToken, (long)page];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://ok.ptjdev.com/api/articlelist/"]];
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
    if (data != nil) {
        [self.listBerita addObjectsFromArray:data];
        [self.tableView reloadData];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[BeritaViewController class]]){
        [(BeritaViewController *)segue.destinationViewController setIdBeritaView:self.idBerita];
        [(BeritaViewController *)segue.destinationViewController setTitle:[self.kategori capitalizedString]];
        
        //Reset Boot Cover
        [self setIdBerita:nil];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUserDefaults *mainNews = [NSUserDefaults standardUserDefaults];
    NSDictionary *berita = [[NSDictionary alloc]init];
    if ([self connected]) {
        berita = [self.listBerita objectAtIndex:[indexPath row]];
    }else{
        if ([mainNews objectForKey:@"news"]) {
            berita = [[mainNews objectForKey:@"news"] objectAtIndex:[indexPath row]];
        }
    }
    
    self.idBerita = [berita objectForKey:@"id"];
    //NSLog(@"%@", self.kategori);
    
    //Perform Segue
    [self performSegueWithIdentifier:@"show_berita" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 300;
    }else{
        return 80;
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
