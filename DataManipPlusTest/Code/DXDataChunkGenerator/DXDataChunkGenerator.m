//
//  DXDataChunkGenerator.m
//  DataManipPlusTest
//
//  Created by Max Mashkov on 12/27/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDataChunkGenerator.h"
#import <DXFoundation/DXFileManager.h>

@implementation DXDataChunkGenerator

- (void)dataChunkForFileAtPath:(NSString *)path
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

- (void)dataChunkForFileAtURL:(NSURL *)URL
                         from:(NSUInteger)startPoint
                       length:(NSUInteger)length
               successHandler:(DXDataChunkGeneratorSuccessHandler)successHandler
                 errorHandler:(DXDataChunkGeneratorErrorHandler)error
{
    NSData *resultData = nil;
    NSInputStream * stream = [[NSInputStream alloc] initWithURL:URL];
    [stream open];
    [stream setProperty:@(startPoint) forKey:NSStreamFileCurrentOffsetKey];

    if([stream streamError]){
        if (error) {
            error([stream streamError]);
        }
    } else {

        Byte * data = (Byte *)malloc(sizeof(Byte)*length);
        NSInteger realLenght = [stream read:data maxLength:length];
        
        if(realLenght == 0 && error){
            
            error([NSError errorWithDomain:@"DXDataChunkGeneratorError"
                                      code:0
                                  userInfo:@{@"errorMessage" : @"The maximum length was exceeded"}]);
            
            return;
        }
        
        NSData *readedData = [[NSData alloc] initWithBytesNoCopy:data length:length freeWhenDone:YES];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        
        NSString *chunkFileName = [NSString stringWithFormat:@"chunk_%@", [URL lastPathComponent]];
        NSString *chunkDataFilePath = [cachesDirectory stringByAppendingPathComponent:chunkFileName];
        
        if ([[DXFileManager defaultManager] fileExistsAtPath:chunkDataFilePath]) {
            [[DXFileManager defaultManager] removeItemAtPath:chunkDataFilePath error:nil];
        }
        
        if ([[DXFileManager defaultManager] createFileAtPath:chunkDataFilePath
                                                    contents:readedData
                                                  attributes:nil]) {

            readedData = nil;
            resultData = [[NSData alloc] initWithContentsOfFile:chunkDataFilePath];
        }

        Byte testByte[1];
        
        BOOL isFinished = !([stream read:testByte maxLength:1]);
        NSUInteger pointer = startPoint + realLenght;
        
        if(successHandler){
            successHandler(resultData, pointer, isFinished);
        }
    }
    [stream close];
}

@end
