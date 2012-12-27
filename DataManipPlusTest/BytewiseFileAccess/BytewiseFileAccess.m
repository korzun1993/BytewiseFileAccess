//
//  BytewiseFileAccess.m
//  DataManipPlusTest
//
//  Created by Корзун Владислав on 26.12.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "BytewiseFileAccess.h"

@implementation BytewiseFileAccess

+(void)dataURL:(NSURL *)URL from:(NSUInteger)startPoint length:(NSUInteger)length successHandler :(void (^)(NSData *, NSUInteger, BOOL))success errorHandler:(void (^)(NSError *))error
{
    NSData *resultData;
    NSInputStream * stream = [NSInputStream inputStreamWithURL:URL];
    [stream open];
    [stream setProperty:[NSNumber numberWithInt:startPoint] forKey:NSStreamFileCurrentOffsetKey];
    
    if([stream streamError]){
        if(error){
            error([stream streamError]);
        }
    } else {
        Byte * data = malloc(sizeof(Byte)*length);
        NSInteger realLenght = [stream read:data maxLength:length];
       
        if(realLenght==0 && error){
                error([NSError errorWithDomain:@"not standard error" code:0 userInfo:[NSDictionary dictionaryWithObject:@"The maximum length was exceeded" forKey:@"error"]]);
        }
        
        resultData = [NSData dataWithBytesNoCopy:data length:length freeWhenDone:YES];
        Byte testByte[1];
        
        if(success){
            success(resultData,startPoint+realLenght,!([stream read:testByte maxLength:1]));
        }
    }
    [stream close];
}

@end
