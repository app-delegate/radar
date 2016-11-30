//
//  RadarView.m
//  Radar
//
//  Created by YUMO on 16/11/30.
//  Copyright © 2016年 YUMO. All rights reserved.
//

#import "RadarView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCROLLVIEW_HEIGHT 40
#define COLOR_UI_RANDOM [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.8]

@interface RadarView ()

@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, strong) CAShapeLayer      *circleLayer;

@property (nonatomic, strong) NSTimer *timerPoint;
@property (nonatomic, strong) NSArray *userArray;

@property (nonatomic, strong) NSMutableArray *showedUserArray;
@property (nonatomic, strong) NSMutableSet *pointSet;

@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *headImageView;


@end

@implementation RadarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        
        self.pointArray = [[NSMutableArray alloc] init];
        self.userArray = [[NSArray alloc] init];
        self.showedUserArray = [[NSMutableArray alloc] init];
        self.pointSet = [[NSMutableSet alloc] init];
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.image = [UIImage imageNamed:@"pipeipic.jpg"];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        UIImage *image = [UIImage imageNamed:@"icon"];
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - image.size.width/2, frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
        _icon.image = image;
        [self addSubview:_icon];
        
        self.gradientLayer = ({
            CAGradientLayer *layer = [CAGradientLayer new];
            [self.layer addSublayer:layer];
            layer;
        });
        
        self.replicatorLayer = ({
            CAReplicatorLayer *layer = [CAReplicatorLayer new];
            
            self.gradientLayer.mask = layer;
            
            layer;
        });
        
        self.circleLayer = ({
            CAShapeLayer *layer = [CAShapeLayer new];
            layer.strokeColor     = [UIColor whiteColor].CGColor;
            layer.fillColor       = [UIColor clearColor].CGColor;
            
            [self.replicatorLayer addSublayer:layer];
            
            layer;
        });
        
        self.minRadius = 20;
        self.maxRadius = 200;
        
        self.duration = 5.0f;
        self.count = 5;
        self.lineWidth = 2.0f;
        
        self.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.15].CGColor,(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.15].CGColor];
        
        self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
    }
    return self;
}

-(void)addOrReplacePoint
{
    NSInteger maxCount = 5;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.layer.cornerRadius = SCROLLVIEW_HEIGHT/2;
    imageView.layer.masksToBounds = YES;
    imageView.alpha = 0;
    imageView.backgroundColor = COLOR_UI_RANDOM;
    [self getUserHeaderImgURL:imageView];
    self.imageView = imageView;
    do {
        CGPoint point = [self generateCenterPointInRadar];
        imageView.frame = CGRectMake(point.x,point.y, SCROLLVIEW_HEIGHT, SCROLLVIEW_HEIGHT);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionCurveLinear animations:^{
            imageView.alpha = 0.5;
        } completion:^(BOOL finished) {
            imageView.alpha = 1;
        }];
    } while ([self itemFrameIntersectsInOtherItem:imageView.frame]);
    
    [self addSubview:imageView];
    [_pointArray addObject:imageView];
    
    __weak typeof(self) __self = self;
    if (_pointArray.count > maxCount) {
        
        UIImageView *imageView = _pointArray[0];
        NSString *string = nil;
        if (_showedUserArray.count != 0) {
            string = _showedUserArray[0];
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionCurveLinear animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (_showedUserArray.count != 0) {
                [__self.pointSet removeObject:string];
                [__self.showedUserArray removeObjectAtIndex:0];
            }
            
            [imageView removeFromSuperview];
            [__self.pointArray removeObject:imageView];
        }];
    }
}

- (void) getUserHeaderImgURL:(UIImageView *)imageView
{
    int x = arc4random() % _userArray.count;
    self.imageView = imageView;
    NSString *u = [_userArray objectAtIndex:x];
    
    if ([_pointSet containsObject:u]) {
        [self getUserHeaderImgURL:_imageView];
    } else {
        
        [self.pointSet addObject:u];
        [self.showedUserArray addObject:u];
        _imageView.image = [UIImage imageNamed:@"icon"];
    }
}

-(CGPoint)generateCenterPointInRadar
{
    double angle = (arc4random()) % 360;
    int i = (200 + SCROLLVIEW_HEIGHT)/2;
    CGFloat radius = (arc4random()) % i;
    CGFloat x = cos(angle) * radius;
    CGFloat y = sin(angle) * radius;
    
    //圆心 X 位置
    if (CGRectContainsPoint(CGRectMake(SCREEN_WIDTH/2 -150/2,SCREEN_HEIGHT/2 -150/2, 150, 150), CGPointMake(x + 200 / 2 ,y + SCREEN_HEIGHT / 2))) {
        CGFloat marginX = 0;
        CGFloat marginY = 0;
        
        if (x < 0 && y >0) {
            marginX = -80;
            
        } else if (x < 0 && y < 0)
        {
            marginX = 80;
        } else if (x > 0 && y < 0)
        {
            marginY = -80;
        } else if (x>0 && y > 0)
        {
            marginX = 80;
            marginY = 80;
            
        }
        return CGPointMake(x + 200 /2 + marginX ,y + SCREEN_WIDTH / 2 + marginY);
        
    } else {
        return CGPointMake(x + 200 / 2 ,y + SCREEN_WIDTH / 2);
    }
    
}



-(BOOL)itemFrameIntersectsInOtherItem:(CGRect)frame
{
    for (UIView *item in _pointArray) {
        if (CGRectIntersectsRect(item.frame, frame)) {
            return YES;
        }
    }
    return NO;
}

- (void)setColors:(NSArray *)colors
{
    self.gradientLayer.colors = colors;
}

- (NSArray *)colors
{
    return self.gradientLayer.colors;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations
{
    self.gradientLayer.locations = locations;
}

- (NSArray *)locations
{
    return self.gradientLayer.locations;
}

- (void)setStartPoint:(CGPoint)startPoint
{
    self.gradientLayer.startPoint = startPoint;
    
}

- (CGPoint)startPoint
{
    return self.gradientLayer.startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    self.gradientLayer.endPoint = endPoint;
}

- (CGPoint)endPoint
{
    return self.gradientLayer.endPoint;
}

- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
    
    if ( _count != 0 )
    {
        self.replicatorLayer.instanceCount = _count;
        self.replicatorLayer.instanceDelay = self.duration/(CGFloat)_count;
    }
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    if ( _count != 0 )
    {
        self.replicatorLayer.instanceCount = _count;
        self.replicatorLayer.instanceDelay = self.duration/(CGFloat)_count;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    self.circleLayer.lineWidth = lineWidth;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
    self.replicatorLayer.frame = self.bounds;
    self.circleLayer.frame     = self.bounds;
}

- (void)startAnimation
{
    CGRect fromRect = CGRectMake(CGRectGetMidX(self.bounds)-self.minRadius, CGRectGetMidY(self.bounds)-self.minRadius, self.minRadius*2, self.minRadius*2);
    CGRect toRect   = CGRectMake(CGRectGetMidX(self.bounds)-self.maxRadius, CGRectGetMidY(self.bounds)-self.maxRadius, self.maxRadius*2, self.maxRadius*2);
    
    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    zoomAnimation.duration          = self.duration;
    zoomAnimation.fromValue         = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:fromRect].CGPath;
    zoomAnimation.toValue           = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:toRect].CGPath;
    zoomAnimation.repeatCount       = HUGE_VAL;
    zoomAnimation.removedOnCompletion = NO;//让雷达后台返回前台继续转动
    zoomAnimation.timingFunction    = self.timingFunction;
    [self.circleLayer addAnimation:zoomAnimation forKey:@"zoom"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    fadeAnimation.duration          = self.duration;
    fadeAnimation.fromValue         = (__bridge id)[UIColor whiteColor].CGColor;
    fadeAnimation.toValue           = (__bridge id)[UIColor clearColor].CGColor;
    fadeAnimation.repeatCount       = HUGE_VAL;
    fadeAnimation.timingFunction    = self.timingFunction;
    fadeAnimation.removedOnCompletion = NO; //让雷达后台返回前台继续转动
    [self.circleLayer addAnimation:fadeAnimation forKey:@"fade"];
    
}

- (void) startAnimationWithItem:(NSArray *)userArray
{
    [_pointSet removeAllObjects];
    [_showedUserArray removeAllObjects];
    _imageView = nil;
    [_imageView removeFromSuperview];
    [_pointArray removeAllObjects];
    
    if (userArray.count != 0 && userArray != nil) {
        
        self.userArray = userArray;
        [self invalidateTimer];
        
        self.timerPoint = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(addOrReplacePoint) userInfo:nil repeats:YES];
    }
}

- (void)stopAnimation
{
    [self invalidateTimer];
    _imageView = nil;
    [_imageView removeFromSuperview];
    [self.circleLayer removeAllAnimations];
    for (UIImageView *imageView in _pointArray) {
        [imageView removeFromSuperview];
    }
    [_pointArray removeAllObjects];
}

- (void) invalidateTimer
{
    if (_timerPoint) {
        [_timerPoint invalidate];
        _timerPoint = nil;
    }
}

@end
