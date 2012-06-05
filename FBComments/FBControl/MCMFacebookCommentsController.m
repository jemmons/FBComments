#import "MCMFacebookCommentsController.h"

#import "Facebook.h"
#import "MCMFacebookCommentsViewController.h"

static const CGFloat kPostHeight = 72.0f;

@interface MCMFacebookCommentsController ()
@property (strong) UINavigationController *navigationController;
@end

@implementation MCMFacebookCommentsController
@synthesize navigationController;

-(id)initWithURL:(NSURL *)aURL andFacebookObject:(Facebook *)aFacebookObject{
  if((self = [super initWithNibName:@"CommentsView" bundle:nil])){
    MCMFacebookCommentsViewController *aViewController = [[MCMFacebookCommentsViewController alloc] initWithURL:aURL andFacebook:aFacebookObject];
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [aNavigationController setDelegate:self];
    [self setNavigationController:aNavigationController];
  }
  return self;
}


-(void)viewDidLoad{
  [super viewDidLoad];
  [[self view] setClipsToBounds:YES];
  
  CGRect bounds = [[self view] bounds];
  bounds.size.height -= kPostHeight;
  [[[self navigationController] view] setFrame:bounds];
  [[self view] addSubview:[[self navigationController] view]];
}


-(void)dealloc{
  [[self navigationController] setDelegate:nil];
}


-(void)navigationController:(UINavigationController *)aNavigationController willShowViewController:(UIViewController *)aViewController animated:(BOOL)isAnimated{
  if(aNavigationController == [self navigationController]){
    if(aViewController == [[aNavigationController viewControllers] objectAtIndex:0]){
      [aNavigationController setNavigationBarHidden:YES animated:isAnimated];
    } else{
      [aNavigationController setNavigationBarHidden:NO animated:isAnimated];    
    }
  }
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

@end
