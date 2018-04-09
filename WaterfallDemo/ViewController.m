//
//  ViewController.m
//  WaterfallDemo
//
//  Created by Ios_Developer on 2018/4/9.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallFlowLayout.h"//-----导入布局对象flowlayout
#import "WaterfallModel.h"//----------导入model

@interface ViewController ()<UICollectionViewDataSource,WaterfallFlowLayoutDelegate>


//视图
@property (nonatomic ,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *footerView;

//data
@property (nonatomic ,assign)int currentPage;
@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    _currentPage = 1;
    
    //初始化控件
    [self loadSubViews];
    //请求数据
    [self downLoadWithPage:_currentPage];
    
    //刷新操作
    [self refreshData];
    
}
#pragma mark  ===== layLoad  =====
-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        //初始化布局对象
        WaterfallFlowLayout *flowLayout = [[WaterfallFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.delegate = self;
        //    //设置头、尾
        //    flowLayout.footerReferenceSize = CGSizeMake(SCREN_WIDTH, 0);
        //    flowLayout.headerReferenceSize = CGSizeMake(SCREN_WIDTH, 90);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        AdjustsScrollViewInsetNever(self, _collectionView);//ios11适配
        
        //长按手势-移动cell
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
        [_collectionView addGestureRecognizer:tap];
    }
    return _collectionView;
}
#pragma mark  =====  initView  =====
-(void)loadSubViews
{
    
    
    //初始化collectionview
    [self.view addSubview:self.collectionView];
    
    //注册
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionV"];
    
    //设置头、尾
//    [collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
    if(_collectionView.contentSize.height < CGRectGetHeight(_collectionView.frame))
        _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
}
#pragma mark =====  downLoad  =====
-(void)refreshData
{
    //下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self downLoadWithPage:_currentPage];
    }];
    //上拉加载
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++self.currentPage;
        [self downLoadWithPage:_currentPage];
    }];
    
}
-(void)downLoadWithPage:(int)page
{
    NSArray * sourceArr = [WaterfallModel mj_objectArrayWithFilename:@"model.plist"];
    NSMutableArray *arr = [NSMutableArray new];
    
    NSInteger iCount = PAGESIZE;
    if (_dataSource.count < sourceArr.count)
    {
        iCount = (page - 1)* PAGESIZE + PAGESIZE > sourceArr.count ? sourceArr.count - _dataSource.count +  (page - 1)* PAGESIZE : (page - 1)* PAGESIZE + PAGESIZE;
    }
    else
    {
        iCount = (page - 1)* PAGESIZE + PAGESIZE;
    }
    
    
    //模拟分页效果，取数据
    for (int i = (page - 1)* PAGESIZE; i < iCount; i ++)
    {
        [arr addObject:sourceArr[i]];
    }
    
    if (arr.count == 0)
    {
        [self handleDatas:@[]];
       
    }
    else
        [self handleDatas:arr];
}
-(void)handleDatas:(NSArray *)datas
{
    //是否是小于每页请求数量
    if (datas.count < PAGESIZE)
    {
        [_collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        [_collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    else
        [_collectionView.mj_footer setState:MJRefreshStateIdle];
    
    //数据
    if (self.currentPage == 1)
        _dataSource = datas.mutableCopy;
    else
        [_dataSource addObjectsFromArray:datas];
    //
    if(!_dataSource||_dataSource.count <= 0)
    {
        NSLog(@"给个空数据图");
    }
    else
    {
        NSLog(@"移除空数据图");
    }
    
    [_collectionView reloadData];
    [self stopAnimation];
}
-(void)stopAnimation
{
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
    if (_collectionView.mj_header.isRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
}
#pragma mark =====  UICollectionViewDataSource  =====
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"collectionV";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indetify forIndexPath:indexPath];
    cell.backgroundColor = Origin_Color;
    
    //此处这样设置layer，会离谱渲染，如果数据量很大，会导致性能损耗较大，出现卡顿。建议进行优化。如何优化？我很笨，还很懒，我不会。自己去找个吧。
    cell.layer.cornerRadius = 7;
    cell.layer.masksToBounds = YES;
    
    //如果cell是自定义不需要，否则，移初子视图，防止重复加载
    for(id subView in cell.contentView.subviews)
    {
        if(subView)
        {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.frame.size.width - 30, cell.frame.size.height)];
    titleL.numberOfLines = 0;
    [cell.contentView addSubview:titleL];
    
    WaterfallModel *waterfallModel = _dataSource[indexPath.item];
    titleL.text = waterfallModel.title;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor redColor];
        [header addSubview:self.headerView];
        return header;
    }
    
    [kind isEqualToString:UICollectionElementKindSectionFooter];
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor greenColor];
    [footer addSubview:self.footerView];
    return footer;
}
#pragma mark  =====  移动cell  =====
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [_collectionView indexPathForItemAtPoint:[longPress locationInView:_collectionView]];
                if (@available(iOS 9.0, *)) {
                    [_collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                } else {
                    // Fallback on earlier versions
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (@available(iOS 9.0, *)) {
                [_collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            } else {
                // Fallback on earlier versions
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (@available(iOS 9.0, *)) {
                [_collectionView endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
        }
        default: if (@available(iOS 9.0, *)) {
            [_collectionView cancelInteractiveMovement];
        } else {
            // Fallback on earlier versions
        }
            break;
    }
}
//移动方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [_collectionView reloadData];
    
#warning 本demo中，加入了移动cell大功能，但是测试发现，不论怎样移动，都会移动到index为0到位置，也就是说，destinationIndexPath.item始终为0。如果collectionview布局不是瀑布流布局，而是正常的均等布局，效果正常。如果你有好的策略，欢迎指教。github issues我（github地址 https://github.com/diankuanghuolong/WaterfallDemo）。
    
    
    
    NSLog(@"sourceIndexPath  == %ld,destinationIndexPath  == %ld",sourceIndexPath.item,destinationIndexPath.item);
}
#pragma mark  =====  WaterfallFlowLayoutDelegate  =====
//必需实现，获取cell高度
-(CGFloat)waterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width//cell高度
{
    WaterfallModel *waterfallModel = _dataSource[index];
    CGFloat h = width * waterfallModel.h/waterfallModel.w;
    return h;
}
//非必需实现部分，不写使用默认值
- (NSInteger)cloumnCountInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout//列数
{
    return 3;
}
- (CGFloat)columMarginInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout//列的距离
{
    return 10;
}
- (CGFloat)rowMarginInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout//行的距离
{
    return 30;
}
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WaterfallFlowLayout *)WaterfallFlowLayout//边缘距
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
