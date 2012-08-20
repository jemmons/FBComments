@class Facebook;

@interface MCMFacebookCommentsController : UIViewController<UINavigationControllerDelegate, UITextViewDelegate>
@property (weak) IBOutlet UITextView *textView;
@property (weak) IBOutlet UIView *postView;
-(id)initWithURL:(NSURL *)aURL;
@end
