
#import "Kiwi.h"

#import "BytewiseFileAccess.h"

#define filePath @"file://localhost/Users/korzun1993/Library/Application%20Support/iPhone%20Simulator/6.0/Applications/1DAFDD54-BBDD-4B8E-88FA-B01689463393/DataManipPlusTest.app/car.png"
#define fileLen 29158

SPEC_BEGIN(NewKiwiSpec)
describe(@"Correct calling", ^{
    it(@"With getting all data from file",^{
        __block BOOL returnedFlag;
        __block NSUInteger startPoint;
        __block NSData * returnedResultData;
     
        NSURL * path = [NSURL URLWithString:filePath];
        [BytewiseFileAccess dataURL:path from:0 length:fileLen successHandler:^(NSData *resultData, NSUInteger pointer, BOOL isFinish) {
            startPoint = pointer;
            returnedFlag = isFinish;
            returnedResultData = resultData;
        } errorHandler:nil];
        [[theValue(startPoint) should] equal:theValue(fileLen)];
        [[theValue(returnedFlag) should]equal:theValue(YES)];
        [[theValue([returnedResultData length]) should]equal:theValue(fileLen)];
    });
    
    it(@"With getting not all data from file",^{
        __block BOOL returnedFlag;
        __block NSUInteger startPoint;
        __block NSData * returnedResultData;
        
        NSURL * path = [NSURL URLWithString:filePath];
        [BytewiseFileAccess dataURL:path from:0 length:fileLen-1 successHandler:^(NSData *resultData, NSUInteger pointer, BOOL isFinish) {
            startPoint = pointer;
            returnedFlag = isFinish;
            returnedResultData = resultData;
        } errorHandler:nil];
        [[theValue(startPoint) should] equal:theValue(fileLen - 1)];
        [[theValue(returnedFlag) should]equal:theValue(NO)];
        [[theValue([returnedResultData length]) should]equal:theValue(fileLen - 1)];
    });
    it(@"Data have to be the same as data that was taken in simple way",^{
            __block BOOL returnedFlag;
            __block NSUInteger startPoint;
            __block NSData * returnedResultData;
            
        NSURL * path = [NSURL URLWithString:filePath];
        [BytewiseFileAccess dataURL:path from:0 length:fileLen successHandler:^(NSData *resultData, NSUInteger pointer, BOOL isFinish) {
            startPoint = pointer;
            returnedFlag = isFinish;
            returnedResultData = resultData;
        } errorHandler:nil];
        [[returnedResultData should]equal:[NSData dataWithContentsOfURL:path]];
    });
   
    it(@"part of data have to be same as part of data that was taken in simple way",^{
        __block BOOL returnedFlag;
        __block NSUInteger startPoint;
        __block NSData * returnedResultData;
        
        NSURL * path = [NSURL URLWithString:filePath];
        [BytewiseFileAccess dataURL:path from:0 length:fileLen-1 successHandler:^(NSData *resultData, NSUInteger pointer, BOOL isFinish) {
            startPoint = pointer;
            returnedFlag = isFinish;
            returnedResultData = resultData;
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
       __block NSError * returnedError;

        NSURL * path = [NSURL URLWithString:@"file://wrongAdress"];

        [BytewiseFileAccess dataURL:path from:0 length:1 successHandler:nil errorHandler:^(NSError * error) {
            returnedError = error;
        }];
        
        [[returnedError.localizedDescription should] equal:@"The operation couldn’t be completed. No such file or directory"];
    });
});

describe(@"bad begin position", ^{
    it(@"uncorect lenght",^{
        __block NSError * returnedError;
        
        NSURL * path = [NSURL URLWithString:filePath];
        [BytewiseFileAccess dataURL:path from:fileLen length:1 successHandler:^(NSData *resultData, NSUInteger pointer, BOOL isFinish) {
            
        } errorHandler:^(NSError * error) {
            returnedError = error;
        }];
      
        [[[returnedError.userInfo objectForKey:@"error"] should] equal:@"The maximum length was exceeded"];
    });
    
});
SPEC_END