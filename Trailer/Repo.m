
@implementation Repo

@dynamic fullName;
@dynamic fork;
@dynamic webUrl;
@dynamic hidden;

+ (Repo*)repoWithInfo:(NSDictionary*)info moc:(NSManagedObjectContext*)moc
{
	Repo *r = [DataItem itemWithInfo:info type:@"Repo" moc:moc];
	r.fullName = [info ofk:@"full_name"];
	r.fork = @([[info ofk:@"fork"] boolValue]);
	r.webUrl = [info ofk:@"html_url"];
	return r;
}

- (void)prepareForDeletion
{
    NSNumber *sid = self.serverId;
    if(sid)
    {
        NSManagedObjectContext *moc = self.managedObjectContext;
        for(PullRequest *r in [PullRequest allItemsOfType:@"PullRequest" inMoc:moc])
        {
            if([r.repoId isEqualToNumber:sid])
            {
                [moc deleteObject:r];
            }
        }
    }
}

+ (NSArray *)visibleReposInMoc:(NSManagedObjectContext *)moc
{
	NSFetchRequest *f = [NSFetchRequest fetchRequestWithEntityName:@"Repo"];
	f.returnsObjectsAsFaults = NO;
	f.predicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
	return [moc executeFetchRequest:f error:nil];
}

+ (NSUInteger)countVisibleReposInMoc:(NSManagedObjectContext *)moc
{
	NSFetchRequest *f = [NSFetchRequest fetchRequestWithEntityName:@"Repo"];
	f.predicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
	return [moc countForFetchRequest:f error:nil];
}

@end
