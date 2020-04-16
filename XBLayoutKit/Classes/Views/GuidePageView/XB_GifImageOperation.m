//
//  XB_GifImageOperation.m
//  GuideView
//
//  Created by Xinbo Hong on 2019/8/27.
//  Copyright © 2019 com.xinbo.pro. All rights reserved.
//

#import "XB_GifImageOperation.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
@interface XB_GifImageOperation () {
    CGImageSourceRef gif;
    NSDictionary *gifProperties;
    size_t index;
    size_t count;
    NSTimer *timer;
}

@end


@implementation XB_GifImageOperation


+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;

    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *webpString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([webpString hasPrefix:@"RIFF"] && [webpString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
    
}

+ (NSString *)contentTypeForImageURL:(NSString *)url {
    NSString *extensionName = url.pathExtension;
    if ([extensionName.lowercaseString isEqualToString:@"jpeg"]) {
        return @"jpeg";
    }
    if ([extensionName.lowercaseString isEqualToString:@"gif"]) {
        return @"gif";
    }
    if ([extensionName.lowercaseString isEqualToString:@"png"]) {
        return @"png";
    }
    return nil;
}



- (instancetype)initWithFrame:(CGRect)frame gifImagePath:(NSString *)gifImagePath {
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:gifImagePath], (CFDictionaryRef)gifProperties);
        count = CGImageSourceGetCount(gif);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(play) userInfo:nil repeats:YES];/**< 0.12->0.06 */
        [timer fire];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame gifImageData:(NSData *)gifImageData {
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithData((CFDataRef)gifImageData, (CFDictionaryRef)gifProperties);
        count = CGImageSourceGetCount(gif);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(play) userInfo:nil repeats:YES];/**< 0.12->0.06 */
        [timer fire];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame gifImageName:(NSString *)gifImageName {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *gif = [gifImageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gif ofType:@"gif"]];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [clearButton setBackgroundColor:[UIColor clearColor]];
        [clearButton addTarget:self action:@selector(activiTap:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 8.0) {
            WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
            webView.backgroundColor = UIColor.clearColor;
            webView.scrollView.scrollEnabled = NO;
            [webView loadData:gifData MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            
            [clearButton setFrame:webView.frame];
            [webView addSubview:clearButton];
            [self addSubview:webView];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIWebView *webView   = [[UIWebView alloc] initWithFrame:frame];
            webView.backgroundColor = UIColor.clearColor;
            webView.scalesPageToFit = YES;
            webView.scrollView.scrollEnabled = NO;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];

            [clearButton setFrame:webView.frame];
            [webView addSubview:clearButton];
            [self addSubview:webView];
#pragma clang diagnostic pop
        }
        
    }
    return self;

}

#pragma mark - --- private functions ---
- (void)play {
    if (count > 0) {
        index ++;
        index = index%count;
        CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
        self.layer.contents = (__bridge id)ref;
        CFRelease(ref);
    } else {
        static dispatch_once_t onceToken;
        // 只执行一次
        dispatch_once(&onceToken, ^{
            NSLog(@"[XB_GifImageOperation-play()]:请检测网络或者http协议");
        });
    }
}

- (void)removeFromSuperview {
    [timer invalidate];
    timer = nil;
    [super removeFromSuperview];
}

- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"activiTap");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
