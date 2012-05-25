@class MCMAsyncImageFetcher;

@protocol MCMAsyncImageFetcherDelegate <NSObject>
@optional
-(void)imageFetcher:(MCMAsyncImageFetcher *)anImageFetcher didFetchImage:(UIImage *)anImage;
-(void)imageFetcher:(MCMAsyncImageFetcher *)anImageFetcher failedToCreateImageFromData:(NSData *)someData;
-(void)imageFetcher:(MCMAsyncImageFetcher *)anImageFetcher failedWithNon200Code:(NSInteger)aStatusCode;
-(void)imageFetcher:(MCMAsyncImageFetcher *)anImageFetcher failedWithError:(NSError *)anError;
@end



@interface MCMAsyncImageFetcher : NSObject
@property (weak) id<MCMAsyncImageFetcherDelegate> delegate;

-(id)initWithURL:(NSURL *)aURL andDelegate:(id<MCMAsyncImageFetcherDelegate>)aDelegate;
@end
