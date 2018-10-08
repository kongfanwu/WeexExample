//
//  DKWXImgLoader.m
//  DemoWeex
//
//  Created by KFW on 2018/9/5.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import "DKWXImgLoader.h"

@implementation DKWXImgLoader

- (NSString *)imageNameForUrl:(NSString *)url {
    NSArray *urlArray = [url componentsSeparatedByString:@"/"];
    if (urlArray.count) {
        return urlArray.lastObject;
    }
    return nil;
}

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)options completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock {
    UIImage *image = [UIImage imageNamed:[self imageNameForUrl:url]];
    if (completedBlock) completedBlock(image, nil, YES);
    return nil;
}

@end
