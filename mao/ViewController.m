//
//  ViewController.m
//  mao
//
//  Created by 丁 一 on 16/3/17.
//  Copyright © 2016年 dianxin. All rights reserved.
//

// for "AF_INET"
#include <sys/socket.h>
//for ifaddrs
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

#import "getgateway.h"


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];    
//    
//    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    iamgeView.image = [UIImage imageNamed:@"fish.jpg"];
//    
//    [self.view addSubview:iamgeView];
//    [self setBlurView:[JCRBlurView new]];
//    
//    [[self blurView] setFrame:CGRectMake(20.f, 20.f, [self.view bounds].size.width-40.f, [self.view bounds].size.height-40.f)];
//    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [self.view addSubview:[self blurView]];
//    
//    self.tool.frame=[UIScreen mainScreen].bounds;
//    self.tool.barStyle = UIBarStyleDefault;
//    self.tool.hidden = IS_AT_LEAST_IOS7 ? NO : YES;
//    self.tool.alpha = IS_AT_LEAST_IOS7 ? 1 : 0.95;
//    self.tool.backgroundColor = IS_AT_LEAST_IOS7 ? UIColorFromRGB(255, 255, 255, 0) : UIColorFromRGB(25, 25, 25, 1);
    
    
    
    
    
    webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [webview setDelegate:self];
    [webview setBackgroundColor:[UIColor clearColor]];
    for (UIView *subView in [webview subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ///webview的弹性
            //            ((UIScrollView *)subView).bounces = NO; //去掉UIWebView的底图
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            
            for (UIView *scrollview in subView.subviews)
            {
                if ([scrollview isKindOfClass:[UIImageView class]])
                {
                    scrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    //NSURL *url1 = [[NSURL alloc]initWithString:@"http://ip.lockview.cn/"];
    NSURL *url1 = [[NSURL alloc]initWithString:@"http://ip.chinaz.com/"];
    [webview loadRequest:[NSURLRequest requestWithURL:url1]];
    [self.view addSubview:webview];
    
    
    
    
    
    
    
//    int startTime =[[NSDate date]timeIntervalSince1970];
//    // Do any additional setup after loading the view, typically from a nib.
//    NSString* routerIP= [self routerIp];
//    NSLog(@"local device ip address----%@",routerIP);
//    
//    
//    //    in_addr_t i =inet_addr("192.168.1.106");
//    //    in_addr_t i =inet_addr("10.27.0.4");
//    in_addr_t i =inet_addr([routerIP cStringUsingEncoding:NSUTF8StringEncoding]);
//    in_addr_t* x =&i;
//    int r= getdefaultgateway(x);
//    //    NSLog(@"r--%d",r);
//    int endTime =[[NSDate date]timeIntervalSince1970];
//    NSLog(@"--starttime:%d,endtime:%d",startTime,endTime);
//    NSLog(@" time cost getting above info is--%ds",endTime-startTime);
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js_result = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('rightinfo').children[0].children[3].innerHTML;"];
    
    NSString *title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"%@",title);
    NSLog(@"--%@",js_result);
    
    
    NSString *js_email_ByName = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('left').children[0].children[1].innerHTML;"];
    
    NSArray *_arr = [js_email_ByName componentsSeparatedByString:@"&nbsp;&nbsp;"];
    NSLog(@"%@",_arr);
    NSLog(@"%@",js_email_ByName);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *js_result = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('rightinfo').children[0].children[3].innerHTML;"];
    
    NSString *title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"%@",title);
    NSLog(@"%@",js_result);
    
    
    NSString *js_email_ByName = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('left').children[0].children[1].innerHTML;"];
    
    NSArray *_arr = [js_email_ByName componentsSeparatedByString:@"&nbsp;&nbsp;"];
    NSLog(@"%@",_arr);
    NSLog(@"%@",js_email_ByName);
    
    return YES;
}







//*/
- (NSString *) routerIp {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        /*/
         int i=255;
         while((i--)>0)
         //*/
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
