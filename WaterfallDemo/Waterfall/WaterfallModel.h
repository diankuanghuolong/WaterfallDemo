//
//  WaterfallModel.h
//  WaterfallDemo
//
//  Created by Ios_Developer on 2018/4/9.
//  Copyright © 2018年 com.Hai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallModel : NSObject

@property (nonatomic ,assign)CGFloat w;//------------每个cell的宽度
@property (nonatomic ,assign)CGFloat h;//------------每个cell的高度
@property (nonatomic ,strong)NSString *title;//------标题
@end
