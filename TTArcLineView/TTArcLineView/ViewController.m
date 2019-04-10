//
//  ViewController.m
//  TTArcLineView
//
//  Created by Maiya on 2019/4/9.
//  Copyright © 2019 Maiya. All rights reserved.
//

#import "ViewController.h"
#import "TTArcLineView.h"

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define homeRingBegincolor UIColorFromRGB(0x06c1ae)  // 首页进度条渐变开始
#define homeRingEndcolor UIColorFromRGB(0x349ec7)  // 首页进度条渐变结束

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    TTArcLineView *arcView = [[TTArcLineView alloc] initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, 300)];
    
    arcView.maxiMum = 600;
    arcView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:arcView];
    arcView.colorsArray = @[(__bridge id)homeRingBegincolor.CGColor,
                            (__bridge id)homeRingEndcolor.CGColor];
    [arcView setProgressStrokeWidth:8 backstrokWidth:12];
    arcView.progressColor = UIColor.redColor;
    arcView.progressTrackColor = [UIColor grayColor];
    arcView.progressValue = 0.2;
    [arcView stroke];/// 开始圆环动画
   
   
    
}

@end
