//
//  ViewController.m
//  Radar
//
//  Created by YUMO on 16/11/30.
//  Copyright © 2016年 YUMO. All rights reserved.
//

#import "ViewController.h"
#import "RadarView.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) RadarView *radarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.radarView = [[RadarView alloc] initWithFrame:self.view.bounds];
    _radarView.hidden = YES;
    [self.view addSubview:_radarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.start = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2,64,100,40)];
    [_start setTitle:@"开始" forState: UIControlStateNormal];
    _start.titleLabel.font = [UIFont systemFontOfSize:14];
    [_start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_start addTarget:self action:@selector(onStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_start];
    
}

- (void) onStartAction:(UIButton *) sender
{
    __weak typeof(self) __self = self;
    
    if (!sender.selected) {
        [_start setTitle:@"停止" forState: UIControlStateNormal];
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        [UIView animateWithDuration:0.3 animations:^{
            __self.radarView.hidden = NO;
        } completion:^(BOOL finished) {
            [__self.radarView startAnimationWithItem:array];
            [__self.radarView startAnimation];
        }];
    } else {
        [_start setTitle:@"开始" forState: UIControlStateNormal];
        [_start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [__self.radarView stopAnimation];
        [UIView animateWithDuration:0.3 animations:^{
            __self.radarView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
    
    sender.selected = !sender.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
