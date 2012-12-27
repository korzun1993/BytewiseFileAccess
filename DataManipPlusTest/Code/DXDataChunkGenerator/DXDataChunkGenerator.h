//
//  DXDataChunkGenerator.h
//  DataManipPlusTest
//
//  Created by Max Mashkov on 12/27/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

typedef void (^DXDataChunkGeneratorSuccessHandler)(NSData *chunkData, NSUInteger pointer, BOOL isFinished);
typedef void (^DXDataChunkGeneratorErrorHandler)(NSError *error);

@interface DXDataChunkGenerator : NSObject

+ (void)dataChunkForFileAtPath:(NSString *)path
                          from:(NSUInteger)startPoint
                        length:(NSUInteger)length
                successHandler:(DXDataChunkGeneratorSuccessHandler)successHandler
                  errorHandler:(DXDataChunkGeneratorErrorHandler)error;

+ (void)dataChunkForFileAtURL:(NSURL *)URL
                         from:(NSUInteger)startPoint
                       length:(NSUInteger)length
               successHandler:(DXDataChunkGeneratorSuccessHandler)successHandler
                 errorHandler:(DXDataChunkGeneratorErrorHandler)error;

@end
