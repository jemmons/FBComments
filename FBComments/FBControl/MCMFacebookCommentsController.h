@class Facebook;

@interface MCMFacebookCommentsController : UINavigationController
+(id)commentsControllerWithURL:(NSURL *)aURL andFacebookObject:(Facebook*)aFacebookObject;
@end
