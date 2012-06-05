@class MCMComment;
@interface MCMDetailViewController : UIViewController

@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UITextView *textView;

-(id)initWithComment:(MCMComment *)aComment;

@end
