//
//  TodayViewController.m
//  HelloWidgetMap
//
//  Created by Ｍasqurin on 2017/7/27.
//  Copyright © 2017年 Ｍasqurin. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)refresh:(id)sender {
    [self downloadWithCompletionHandler:nil];
}

- (IBAction)launch:(id)sender {
    
}
-(void) downloadWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    NSString * urlString = @"https://attach2.mobile01.com/image/news/8be552f928a2ece4a18bc848d48d2206.jpg";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Download Error: %@",error);
            return ;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainImageView.image = image;
        });
        
    }];
    [task resume];
    
    
}


@end
