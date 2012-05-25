#import "MCMFacebookCommentsController.h"

#import "Facebook.h"
#import "MCMFacebookCommentsViewController.h"

@interface MCMFacebookCommentsController ()
@end

@implementation MCMFacebookCommentsController

+(id)commentsControllerWithURL:(NSURL *)aURL andFacebookObject:(Facebook*)aFacebookObject{
  MCMFacebookCommentsViewController *aViewController = [[MCMFacebookCommentsViewController alloc] initWithURL:aURL andFacebook:aFacebookObject];
  MCMFacebookCommentsController *commentsController = [[MCMFacebookCommentsController alloc] initWithRootViewController:aViewController];
  return commentsController;
}

-(void)viewDidLoad{
  [super viewDidLoad];
}


-(void)viewDidUnload{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

@end
