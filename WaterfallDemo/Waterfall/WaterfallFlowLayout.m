//
//  WaterfallFlowLayout.m
//  WaterfallDemo
//
//  Created by Ios_Developer on 2018/4/9.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import "WaterfallFlowLayout.h"

//在.m中设置默认列数为3列，默认列间距，默认行间距，边缘间距 在.h中开放相同属性，如果使用的时候不做设置，则使用下面默认值

static const CGFloat columCount = 3;//------------------------------列数
static const CGFloat columMargin = 10;//----------------------------每一列间距
static const CGFloat rowMargin = 10;//------------------------------每一行间距
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};//------边缘间距

@interface WaterfallFlowLayout()

@property (nonatomic,strong) NSMutableArray *attrsArray;//----------布局属性数组
@property (nonatomic,strong) NSMutableArray *columnHeight;//--------存放所有列的当前高度
@end

@implementation WaterfallFlowLayout
#pragma mark  =====  layload  =====
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeight
{
    if (!_columnHeight) {
        
        _columnHeight = [NSMutableArray array];
    }
    return _columnHeight;
}

#pragma mark  =====  prepareLayout  =====
- (void)prepareLayout
{
    [super prepareLayout];
    
    //如果刷新布局就会重新调用prepareLayout这个方法,所以要先把高度数组清空
    [self.columnHeight removeAllObjects];
    for (int i = 0; i < self.columCount; i++) {
        
        [self.columnHeight addObject:@(self.defaultEdgeInsets.top)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    [self.attrsArray removeAllObjects];
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取indexPath 对应cell 的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
}

#pragma mark  =====  layoutAttributesForItemAtIndexPath  =====
//返回对应位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //使用for循环,找出高度最短的那一列
    //最短高度的列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeight[0] doubleValue];
    
    for (NSInteger i = 1; i < self.columCount; i++) {
        
        CGFloat columnHeight  =[self.columnHeight[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat w = (self.collectionView.frame.size.width - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin )/self.columCount;
    
   //计算cell的高度，通过代理方法，在调用的控制器中，获取
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
    
    CGFloat x = self.defaultEdgeInsets.left + destColumn*(w + self.columMargin);
    CGFloat y = minColumnHeight ;
    
    if (y != self.defaultEdgeInsets.top) {
        
        y += self.rowMargin;
    }
    
    attr.frame = CGRectMake(x,y,w,h);
    
    self.columnHeight[destColumn] =  @(y+ h);
    return attr;
}

#pragma mark  =====  layoutAttributesForElementsInRect  =====
//决定cell 的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
#pragma mark  ======  collectionViewContentSize  =====
//决定collectionView的可滚动范围
- (CGSize)collectionViewContentSize
{
    
    CGFloat maxHeight = [self.columnHeight[0] doubleValue];
    for (int i = 1; i < self.columCount; i++) {
        
        CGFloat value = [self.columnHeight[i] doubleValue];
        if (maxHeight < value) {
            
            maxHeight = value;
        }
    }
    return CGSizeMake(0, maxHeight+self.defaultEdgeInsets.bottom);
}
#pragma mark =====  delegate  =====
- (NSInteger)columCount{
    
    if ([self.delegate respondsToSelector:@selector(cloumnCountInWaterFlowLayout:)]) {
        return  [self.delegate cloumnCountInWaterFlowLayout:self];
    }
    else{
        return columCount;
    }
}

- (CGFloat)columMargin{
    
    if ([self.delegate respondsToSelector:@selector(columMarginInWaterFlowLayout:)]) {
        return  [self.delegate columMarginInWaterFlowLayout:self];
    }
    else{
        return columMargin;
    }
}

- (CGFloat)rowMargin{
    
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return  [self.delegate rowMarginInWaterFlowLayout:self];
    }
    else{
        return rowMargin;
    }
}

- (UIEdgeInsets)defaultEdgeInsets{
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetInWaterFlowLayout:)]) {
        return  [self.delegate edgeInsetInWaterFlowLayout:self];
    }
    else{
        return defaultEdgeInsets;
    }
}
@end
