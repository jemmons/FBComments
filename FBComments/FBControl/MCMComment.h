#import "MCMAsyncImageFetcher.h"
@class MCMComment;

FOUNDATION_EXPORT NSString * const MCMCommentDidUpdateDataNotification;

@protocol MCMCommentDelegateProtocol <NSObject>
@optional
-(void)commentDidUpdateValues:(MCMComment *)aComment;
@end

@interface MCMComment : NSObject <MCMAsyncImageFetcherDelegate>
@property (copy) NSString *comment;
@property (copy) NSString *name;
@property (copy) NSURL *profileImageURL;
@property (retain, nonatomic) UIImage *profileImage;
@property (getter = isIndented) BOOL indented;
@end
