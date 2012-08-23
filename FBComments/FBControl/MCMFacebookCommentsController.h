@class Facebook;

@interface MCMFacebookCommentsController : UIViewController<UINavigationControllerDelegate, UITextViewDelegate>
@property (weak) IBOutlet UITextView *textView;
@property (weak) IBOutlet UIView *postView;
@property (weak) IBOutlet UIButton *connectButton;
@property (weak) IBOutlet UIButton *postButton;
-(id)initWithURL:(NSURL *)aURL;
@end
