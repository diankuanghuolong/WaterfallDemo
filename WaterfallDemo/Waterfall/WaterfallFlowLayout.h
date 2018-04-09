//
//  WaterfallFlowLayout.h
//  WaterfallDemo
//
//  Created by Ios_Developer on 2018/4/9.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterfallFlowLayout;

@protocol WaterfallFlowLayoutDelegate <NSObject>

@required
//决定cell的高度,必须实现方法
- (CGFloat)waterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width;

@optional
//决定cell的列数
- (NSInteger)cloumnCountInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout;

//决定cell 的列的距离
- (CGFloat)columMarginInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout;

//决定cell 的行的距离
- (CGFloat)rowMarginInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout;

//决定cell 的边缘距
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout;

@end

@interface WaterfallFlowLayout : UICollectionViewFlowLayout

/**代理*/
@property (nonatomic,assign) id <WaterfallFlowLayoutDelegate>delegate;

//在.m中设置默认列数为3列，默认列间距，默认行间距，边缘间距 在.h中开放相同属性，如果使用的时候不做设置，则使用下面默认值
- (NSInteger)columCount;//----------------------------列数
- (CGFloat)columMargin;//-----------------------------每一列间距
- (CGFloat)rowMargin;//-------------------------------每一行间距
- (UIEdgeInsets)defaultEdgeInsets;//------------------边缘间距

@end
