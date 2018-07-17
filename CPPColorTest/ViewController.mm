//
//  ViewController.m
//  CPPColorTest
//
//  Created by 黄威 on 2018/7/16.
//  Copyright © 2018年 黄威. All rights reserved.
//

#import "ViewController.h"
#import "LColorTable.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray * strings = @[@"0x00FF00,0.00",
                          @"0xFFFF00,0.50",
                          @"0xFF0000,1.00"];
    
    
    LDecoderColorTable d = LDecoderColorTable(&strings);
    NSMutableArray * colors = d.Colors(9);
    
    for (UIColor * color in colors)
    {
        CGFloat R,G,B,A = 0.0;
        [color getRed:&R green:&G blue:&B alpha:&A];
        R *= 255.0;
        G *= 255.0;
        B *= 255.0;
        NSString * result = [NSString stringWithFormat:@"%.0f %.0f %.0f %.2f",R,G,B,A];
        NSLog(result);
    }
    
    UIView * view = [[UIView alloc] initWithFrame: self.view.bounds];
    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
