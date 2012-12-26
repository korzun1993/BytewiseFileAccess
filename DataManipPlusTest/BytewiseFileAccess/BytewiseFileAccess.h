//
//  BytewiseFileAccess.h
//  DataManipPlusTest
//
//  Created by Корзун Владислав on 26.12.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BytewiseFileAccess : NSObject
+(void)dataURL:(NSURL *)URL from:(NSUInteger)startPoint length:(NSUInteger)length successHandler :(void (^)(NSData *, NSUInteger, BOOL))success errorHandler:(void (^)(NSError *))error;
@end
