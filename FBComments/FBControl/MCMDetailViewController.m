#import "MCMDetailViewController.h"
#import "MCMComment.h"

@interface MCMDetailViewController ()
@property (weak) id dataDidUpdateObserver;
@property (weak) MCMComment *comment;
@end

@implementation MCMDetailViewController
@synthesize imageView, textView;
@synthesize comment;
@synthesize dataDidUpdateObserver;

-(id)initWithComment:(MCMComment *)aComment{
  if((self = [super initWithNibName:@"DetailView" bundle:nil])){
    [self setComment:aComment];
    [[self navigationItem] setTitle:[aComment name]];
    UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStyleDone target:self action:@selector(likeTapped:)];
    [[self navigationItem] setRightBarButtonItem:likeButton];
    
    [self setDataDidUpdateObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMCommentDidUpdateDataNotification object:[self comment] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
      [[self imageView] setImage:[[self comment] profileImage]];
    }]];
  }
  return self;
}


-(void)viewDidLoad{
  [[self imageView] setImage:[[self comment] profileImage]];
  [[self textView] setText:[[self comment] comment]];
}


-(void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:[self dataDidUpdateObserver]];
}


-(IBAction)likeTapped:(id)sender{
  NSLog(@"LIKE!");
}
     
@end
