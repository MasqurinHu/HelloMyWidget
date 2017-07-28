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
    
    self.preferredContentSize = CGSizeMake(320.0, 320.0); //for ios9 and before 10之後需要再exp模式下才有用
    //預設com 宰版 設定exp可支援展開
    //檢查這個事件是否支援這個方法 比版本判斷更好用
    if ([self.extensionContext respondsToSelector:@selector(widgetLargestAvailableDisplayMode)]) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
}

//顯示模式被切換呼叫
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                        withMaximumSize:(CGSize)maxSize{
    //大小切換做什麼
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        //        self.preferredContentSize = CGSizeMake(100.0, 100.0);
    }else if (activeDisplayMode == NCWidgetDisplayModeExpanded){
        self.preferredContentSize = CGSizeMake(320.0, 320.0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//widget一起動就呼叫 user沒有使用也會呼叫 因user任何時候都能使用widget
//背景持續更新給user 蘋果機制判斷呼叫時機
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData成功sever資料沒更新
    // If there's an update, use NCUpdateResultNewData成功有資料
    //系統收集資料 判斷系統呼叫頻率
    [self downloadWithCompletionHandler:completionHandler];

//    completionHandler(NCUpdateResultNewData);
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
            //下載失敗回報
            if (completionHandler != nil) {
                completionHandler(NCUpdateResultFailed);
            }
            return ;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainImageView.image = image;
        });
        
        //下載成功回報 正常需要保存記錄 比對是否重複下載
        if (completionHandler != nil) {
            completionHandler(NCUpdateResultNewData);
        }
        
    }];
    [task resume];
    
    
}


@end
