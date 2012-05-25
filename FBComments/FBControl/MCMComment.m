#import "MCMComment.h"

NSString * const MCMCommentDidUpdateDataNotification = @"MCM comment did update data notificaiton";


@implementation MCMComment
@synthesize comment, name, profileImage, profileImageURL, indented;

-(id)init{
  if((self = [super init])){
    indented = NO;
  }
  return self;
}


-(UIImage *)profileImage{
  if(nil == profileImage){
    [self setProfileImage:[UIImage imageNamed:@"socialplaceholder.png"]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[MCMAsyncImageFetcher alloc] initWithURL:[self profileImageURL] andDelegate:self];
#pragma clang diagnostic pop
  }

  return profileImage;
}


#pragma mark - FETCHER DELEGATES
-(void)imageFetcher:(MCMAsyncImageFetcher *)anImageFetcher didFetchImage:(UIImage *)anImage{
  [self setProfileImage:anImage];
  [[NSNotificationCenter defaultCenter] postNotificationName:MCMCommentDidUpdateDataNotification object:self];
}

@end
