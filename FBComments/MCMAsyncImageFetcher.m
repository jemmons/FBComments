#import "MCMAsyncImageFetcher.h"

@interface MCMAsyncImageFetcher ()
@property (strong) NSMutableData *imageData;
@property NSInteger imageStatusCode;
@end

@implementation MCMAsyncImageFetcher
@synthesize delegate;
@synthesize imageData, imageStatusCode;

//This will retain itself becasue there's a retain cycle between this and its connection (which it is the delegate of). When the delegate is released (after the connection returns or fails), it will self-destruct safely.
-(id)initWithURL:(NSURL *)aURL andDelegate:(id<MCMAsyncImageFetcherDelegate>)aDelegate{
  if((self = [super init])){
    [self setDelegate:aDelegate];
    NSURLRequest *req = [NSURLRequest requestWithURL:aURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
    [NSURLConnection connectionWithRequest:req delegate:self];
  }
  return self;
}


#pragma mark - CONNECTION DELEGATES
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  [self setImageStatusCode:[(NSHTTPURLResponse *)response statusCode]];
  
	long long contentLength = [response expectedContentLength];
  if (contentLength == NSURLResponseUnknownLength) {
    contentLength = 200000;
  }
  [self setImageData:[NSMutableData dataWithCapacity:(NSUInteger)contentLength]];  
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  [[self imageData] appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
  if(200 == [self imageStatusCode]){
    UIImage *anImage = [UIImage imageWithData:[self imageData]];
    if(anImage){
      if([[self delegate] respondsToSelector:@selector(imageFetcher:didFetchImage:)]){
        [[self delegate] imageFetcher:self didFetchImage:anImage];
      }
    } else{
      NSLog(@"MCMAsyncImageView: Error loading image.");
      if([[self delegate] respondsToSelector:@selector(imageFetcher:failedToCreateImageFromData:)]){
        [[self delegate] imageFetcher:self failedToCreateImageFromData:[self imageData]];
      }
    }    
  } else{
    NSLog(@"MCMAsyncImageView: Error retrieving image. Status %d", [self imageStatusCode]);
    if([[self delegate] respondsToSelector:@selector(imageFetcher:failedWithNon200Code:)]){      
      [[self delegate] imageFetcher:self failedWithNon200Code:[self imageStatusCode]];
    }
  }
  [self setImageData:nil];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  NSLog(@"MCMAsyncImageView: Error retrieving image.");
  if([[self delegate] respondsToSelector:@selector(imageFetcher:failedWithError:)]){
    [[self delegate] imageFetcher:self failedWithError:error];
  }
  [self setImageData:nil];
}


@end
