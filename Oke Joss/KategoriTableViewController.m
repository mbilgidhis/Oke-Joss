//
//  KategoriTableViewController.m
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import "KategoriTableViewController.h"
#import "SWRevealViewController.h"
#import "beritaListTableViewCell.h"
#import "BeritaViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface KategoriTableViewController ()

@end

@implementation KategoriTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = [self.kategori capitalizedString];
    
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    NSUserDefaults *kategoriNews = [NSUserDefaults standardUserDefaults];
    
    if (![self connected]) {
        if ([kategoriNews objectForKey:self.kategori]) {
            UIAlertView *offline = [[UIAlertView alloc] initWithTitle:@"Offline Mode" message:@"Anda berada pada offline mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [offline show];
        }else{
            UIAlertView *notConnected = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Tidak Ada Koneksi Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
           
            [notConnected show];
        }
        
    }else{
        
        _page = 2;
        NSString *apiId = @"okjapi";
        NSString *apiToken = @"843nthkm4k";
        NSString *kategori = self.kategori;
    
        NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@&category=%@", apiId, apiToken, kategori];
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
        //NSLog(@"%@", data);
        self.listBerita = [[NSMutableArray alloc] init];
        [self.listBerita addObjectsFromArray:data];
        //self.listBerita = [data copy];
        
        if ([kategoriNews objectForKey:self.kategori]) {
            [kategoriNews removeObjectForKey:self.kategori];
            [kategoriNews setObject:self.listBerita forKey:self.kategori];
            [kategoriNews synchronize];
        }else{
            [kategoriNews setObject:self.listBerita forKey:self.kategori];
            [kategoriNews synchronize];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.listBerita count];
    NSUserDefaults *kategori = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        return  [self.listBerita count];
    }else{
        if ([kategori objectForKey:self.kategori]) {
            return [[kategori objectForKey:self.kategori] count];
        }else{
            return 0;
        }
    }
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSUserDefaults *kategori = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        if (self.listBerita.count > 0) {
            return 1;
        }else{
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"Belum Ada Berita pada Kategori Ini.";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [messageLabel sizeToFit];
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }else{
        if ([kategori objectForKey:self.kategori]) {
            return 1;
        }else{
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"Tidak ada koneksi internet.";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [messageLabel sizeToFit];
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *listBeritaIdentifier = @"beritaList";
    NSUserDefaults *kategori = [NSUserDefaults standardUserDefaults];
    beritaListTableViewCell *cell = (beritaListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:listBeritaIdentifier];
    if ([self connected]) {
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"beritaList" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.judul.text = [[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        //NSString *url = [NSString stringWithFormat:[[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
        [cell.gambar sd_setImageWithURL:[[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"imageurl"]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        // Configure the cell...
        return cell;
    }else{
        if ([kategori objectForKey:self.kategori]) {
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"beritaList" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.judul.text = [[[kategori objectForKey:self.kategori] objectAtIndex:indexPath.row] objectForKey:@"title"];
            //NSString *url = [NSString stringWithFormat:[[self.listBerita objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
            [cell.gambar sd_setImageWithURL:[[[kategori objectForKey:self.kategori] objectAtIndex:indexPath.row] objectForKey:@"imageurl"]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            // Configure the cell...
            return cell;
        }else{
            return nil;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if indexPath.row is last row
    if ([self connected]) {
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        if (_page <= 10){
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
    NSString *kategori = self.kategori;
    //NSLog(@"%lu", page);
    NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@&category=%@&page=%lu", apiId, apiToken, kategori,(long) page];
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
    if (data.count > 0){
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
    NSDictionary *berita = [[NSDictionary alloc] init];
    NSUserDefaults *beritaOffline = [NSUserDefaults standardUserDefaults];
    if ([self connected]) {
        berita = [self.listBerita objectAtIndex:[indexPath row]];
    }else{
        if ([beritaOffline objectForKey:self.kategori]) {
            berita = [[beritaOffline objectForKey:self.kategori] objectAtIndex:[indexPath row]];
        }
    }
    
    //NSDictionary *berita = [self.listBerita objectAtIndex:[indexPath row]];
    self.idBerita = [berita objectForKey:@"id"];
    //NSLog(@"%@", self.kategori);

    [self performSegueWithIdentifier:@"push_to_view_berita" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
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
