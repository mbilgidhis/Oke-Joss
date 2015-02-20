//
//  BeritaViewController.m
//  Oke Joss
//
//  Created by Andi Baskoro on 1/21/15.
//  Copyright (c) 2015 Gadga. All rights reserved.
//

#import "BeritaViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface BeritaViewController ()

@end

@implementation BeritaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"%@", self.idBeritaView);
    NSUserDefaults *berita = [NSUserDefaults standardUserDefaults];
    NSString *kategori = [self.title lowercaseString];
    NSString *idBerita = self.idBeritaView;
    
    if (kategori == nil) {
        kategori = @"news";
    }
    
    if (![self connected]) {
        if ([berita objectForKey:kategori]) {
            //NSLog(@"%@", [berita objectForKey:kategori]);
            NSDictionary *beritaOffline = [[NSDictionary alloc]init];
            //NSLog(@"%i",[[berita objectForKey:kategori]count]);
            for (int x = 0; x < [[berita objectForKey:kategori] count]; x++) {
                if ([[[[berita objectForKey:kategori] objectAtIndex:x] objectForKey:@"id"] isEqualToString:idBerita]) {
                    beritaOffline = [[berita objectForKey:kategori] objectAtIndex:x];
                    
                }
            }
            NSLog(@"%@", idBerita);
            NSLog(@"%@", beritaOffline);
            
            self.judul.text = [beritaOffline objectForKey:@"title"];
            
            
            NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
            [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *publishDate = [[NSDate alloc] init];
            publishDate = [formatDate dateFromString:[beritaOffline objectForKey:@"publishdate"]];
            
            NSDateFormatter *formatTanggal = [[NSDateFormatter alloc] init];
            NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"id"];
            [formatTanggal setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
            [formatTanggal setLocale:locale];
            NSString *output = [formatTanggal stringFromDate:publishDate];
            self.tanggal.text = output;
            
            [self.gambar sd_setImageWithURL:[NSURL URLWithString:[beritaOffline objectForKey:@"imageurl"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            self.tulisan.text = [beritaOffline objectForKey:@"text"];
            self.tulisan.textAlignment = NSTextAlignmentJustified;
            
            CGFloat scrollViewHeight = 0.0f;
            for (UIView* view in self.contentView.subviews)
            {
                scrollViewHeight += view.frame.size.height;
            }
            
            [self.content setContentSize:(CGSizeMake(self.contentView.frame.size.width, scrollViewHeight))];
            
        }else{
            UIAlertView *notConnected = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Tidak Ada Koneksi Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [notConnected show];
        }
    }else {
        NSString *apiId = @"okjapi";
        NSString *apiToken = @"843nthkm4k";
        
    
        NSString *post = [NSString stringWithFormat:@"apiId=%@&apiToken=%@&id=%@", apiId, apiToken, idBerita];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://ok.ptjdev.com/api/article/"]];
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
        self.isiBerita = [data copy];
        //NSLog(@"%@", data);
    
        self.judul.text = [self.isiBerita objectForKey:@"title"];
    
    
        NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
        [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *publishDate = [[NSDate alloc] init];
        publishDate = [formatDate dateFromString:[self.isiBerita objectForKey:@"publishdate"]];
    
        NSDateFormatter *formatTanggal = [[NSDateFormatter alloc] init];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"id"];
        [formatTanggal setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
        [formatTanggal setLocale:locale];
        NSString *output = [formatTanggal stringFromDate:publishDate];
        self.tanggal.text = output;
    
        [self.gambar sd_setImageWithURL:[NSURL URLWithString:[self.isiBerita objectForKey:@"imageurl"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
        self.tulisan.text = [self.isiBerita objectForKey:@"text"];
        self.tulisan.textAlignment = NSTextAlignmentJustified;
    
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in self.contentView.subviews)
        {
            scrollViewHeight += view.frame.size.height;
        }
        
        [self.content setContentSize:(CGSizeMake(self.contentView.frame.size.width, scrollViewHeight))];
    }
}

- (BOOL)connected{
    Reachability *internet = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internet currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)viewDidAppear:(BOOL)animated{
    CGRect frame = _tulisan.frame;
    frame.size.height = [_tulisan sizeThatFits:CGSizeMake(_tulisan.frame.size.width, MAXFLOAT)].height;
    _tulisan.frame = frame;
    [self.tulisan sizeToFit];
}

- (void) viewDidLayoutSubviews{
    //[self.content setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.contentView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [self.content setContentSize:(CGSizeMake(self.contentView.frame.size.width, scrollViewHeight))];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
