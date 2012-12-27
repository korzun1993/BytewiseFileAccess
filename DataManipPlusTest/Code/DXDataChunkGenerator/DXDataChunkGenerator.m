//
//  DXDataChunkGenerator.m
//  DataManipPlusTest
//
//  Created by Max Mashkov on 12/27/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDataChunkGenerator.h"

@implementation DXDataChunkGenerator

+ (void)dataChunkForFileAtPath:(NSString *)path
                          from:(NSUInteger)startPoint
                        length:(NSUInteger)length
                successHandler:(DXDataChunkGeneratorSuccessHandler)successHandler
                  errorHandler:(DXDataChunkGeneratorErrorHandler)error
{
    return [self dataChunkForFileAtURL:[NSURL URLWithString:path]
                                  from:startPoint
                                length:length
                        successHandler:successHandler
                          errorHandler:error];
}

+ (void)dataChunkForFileAtURL:(NSURL *)URL
                         from:(NSUInteger)startPoint
                       length:(NSUInteger)length
               successHandler:(DXDataChunkGeneratorSuccessHandler)successHandler
                 errorHandler:(DXDataChunkGeneratorErrorHandler)error
{
    NSInputStream * stream =[[NSInputStream alloc] initWithURL:URL];
    [stream open];
    [stream setProperty:[[NSNumber alloc] initWithInteger:startPoint] forKey:NSStreamFileCurrentOffsetKey];

    if([stream streamError]){
        if (error) {
            error([stream streamError]);
        }
    } else {

        Byte * data = malloc(sizeof(Byte)*length);
        NSInteger realLength = [stream read:data maxLength:length];
        NSLog(@"real len---%d",realLength);
        if(realLength <= 0){
            if(error){
            
                error([NSError errorWithDomain:@"DXDataChunkGeneratorError"
                                      code:0
                                  userInfo:@{@"errorMessage" : @"The maximum length was exceeded"}]);
            }
            return;
        }
        
        NSData *resultData = [[NSData alloc] initWithBytesNoCopy:data length:length];

        Byte *testByte = malloc(sizeof(Byte));
        
        BOOL isFinished = ![stream read:testByte maxLength:1];
        NSUInteger pointer = startPoint + length;
        
        if (successHandler) {
            successHandler(resultData, pointer, isFinished);
        }
        free(testByte);
    }
    [stream close];
    stream = nil;
}

@end
