//
//  RadarView.h
//  Radar
//
//  Created by YUMO on 16/11/30.
//  Copyright © 2016年 YUMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarView : UIView

@property (nonatomic, assign) CGPoint    startPoint;
@property (nonatomic, assign) CGPoint    endPoint;

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) CGFloat    duration;

@property (nonatomic, assign) CGFloat    minRadius;
@property (nonatomic, assign) CGFloat    maxRadius;
@property (nonatomic, assign) CGFloat    lineWidth;

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

- (void)startAnimation;
- (void)stopAnimation;
- (void) startAnimationWithItem:(NSArray *)userArray;


@end
