#import "Facebook+Comments.h"

@implementation Facebook (Comments)

-(void)fetchCommentsForURL:(NSURL *)url delegate:(id)aDelegate{
	NSString* fql = [NSString stringWithFormat:@"{\"comments\":\"SELECT fromid, text, time, comments FROM comment WHERE object_id IN (SELECT comments_fbid FROM link_stat WHERE url ='http://web.graphicly.com/action-lab-entertainment/princeless/1')\", \"users\":\"SELECT name, id FROM profile WHERE id IN (SELECT fromid FROM #comments)\"}", url];

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"queries"];
	
	[self requestWithMethodName:@"fql.multiquery" andParams:params andHttpMethod:@"GET" andDelegate:aDelegate];
}

@end
