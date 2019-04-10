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
    TTArcLineView *arcView = [[TTArcLineView alloc] initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, 300) beginColor:homeRingBegincolor endColor:homeRingEndcolor];
    
    arcView.maxiMum = 600;
    arcView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:arcView];
    [arcView setProgressStrokeWidth:8 backstrokWidth:12];
    arcView.progressTrackColor = [UIColor grayColor];
    arcView.internalArcColor = [[UIColor alloc] initWithRed:245/255 green:245/255 blue:245/255 alpha:0.15];
    arcView.progressValue = 0.9;
    [arcView stroke];/// 开始圆环动画
   
}

@end
