
# prefix "-" sets descending


# by semantic versioning ( ex: 1.2.0, 1.10.0 )
git tag --sort=-v:refname

# by alphabetical
git tag --sort=-refname

# by creation time
git tag --sort=-creatordate

# Alternative: Closest Tag to Current CommitIf by "newest" you meant the most recent tag created in the commit history of your active branch,
# you should use git describe instead
git describe --tags --abbrev=0
