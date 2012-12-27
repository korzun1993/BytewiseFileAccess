
#import "Kiwi.h"

#import "DXDataChunkGenerator.h"

#define fileLen 29158

SPEC_BEGIN(NewKiwiSpec)

__block BOOL returnedFlag;
__block NSUInteger startPoint;
__block NSData * returnedResultData;
__block NSURL * path;
__block NSError * returnedError;

beforeEach(^{
    returnedFlag = NO;
    startPoint = 0;
    returnedResultData = nil;
    returnedError = nil;
    path = [[NSBundle mainBundle] URLForResource:@"car" withExtension:@"png"];
});

describe(@"Correct calling", ^{
 
    it(@"With getting all data from file",^{
        
        [DXDataChunkGenerator dataChunkForFileAtURL:path
                                               from:0
                                             length:fileLen
                                      successHandler:^(NSData *chunkData, NSUInteger pointer, BOOL isFinished) {
                                          startPoint = pointer;
                                          returnedFlag = isFinished;
                                          returnedResultData = chunkData;
                                      } errorHandler:nil];
        
        [[theValue(startPoint) should] equal:theValue(fileLen)];
        [[theValue(returnedFlag) should]equal:theValue(YES)];
        [[theValue([returnedResultData length]) should]equal:theValue(fileLen)];
    });
    
    it(@"With getting not all data from file",^{
        
        [DXDataChunkGenerator dataChunkForFileAtURL:path
                                                from:0
                                              length:fileLen - 1
                                      successHandler:^(NSData *chunkData, NSUInteger pointer, BOOL isFinished) {
                                          startPoint = pointer;
                                          returnedFlag = isFinished;
                                          returnedResultData = chunkData;
                                      } errorHandler:nil];

        [[theValue(startPoint) should] equal:theValue(fileLen - 1)];
        [[theValue(returnedFlag) should]equal:theValue(NO)];
        [[theValue([returnedResultData length]) should]equal:theValue(fileLen - 1)];
    });
    
    it(@"Data have to be the same as data that was taken in simple way",^{
        
        [DXDataChunkGenerator dataChunkForFileAtURL:path
                                                from:0
                                              length:fileLen
                                      successHandler:^(NSData *chunkData, NSUInteger pointer, BOOL isFinished) {
                                          startPoint = pointer;
                                          returnedFlag = isFinished;
                                          returnedResultData = chunkData;
                                      } errorHandler:nil];

        [[returnedResultData should]equal:[NSData dataWithContentsOfURL:path]];
    });
   
    it(@"part of data have to be same as part of data that was taken in simple way",^{
        
        [DXDataChunkGenerator dataChunkForFileAtURL:path
                                                from:0
                                              length:fileLen - 1
                                      successHandler:^(NSData *chunkData, NSUInteger pointer, BOOL isFinished) {
                                          startPoint = pointer;
                                          returnedFlag = isFinished;
                                          returnedResultData = chunkData;
                                      } errorHandler:nil];
        
        NSData *data = [NSData dataWithContentsOfURL:path];
        NSUInteger len = [data length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [data bytes], len);
        
        [[returnedResultData should]equal:[NSData dataWithBytesNoCopy:byteData length:len-1 freeWhenDone:YES]];
    });
});
describe(@"bad url", ^{
    it(@"uncorect url",^{

        NSURL * url = [NSURL URLWithString:@"file://wrongAdress"];

        [DXDataChunkGenerator dataChunkForFileAtURL:url
                                                from:0
                                              length:1
                                      successHandler:nil
                                        errorHandler:^(NSError *error) {
                                            returnedError = error;
                                        }];
        
        [[returnedError.localizedDescription should] equal:@"The operation couldn’t be completed. No such file or directory"];
    });
});

describe(@"bad begin position", ^{
    it(@"uncorect start point",^{
        
        [DXDataChunkGenerator dataChunkForFileAtURL:path
                                                from:0
                                              length:1
                                      successHandler:nil
                                        errorHandler:^(NSError *error) {
                                            returnedError = error;
                                        }];
      
        [[[returnedError.userInfo objectForKey:@"errorMessage"] should] equal:@"The maximum length was exceeded"];
    });
    
});
SPEC_END