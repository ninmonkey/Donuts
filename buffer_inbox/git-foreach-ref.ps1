<#
    file:///C:/Program%20Files/Git/mingw64/share/doc/git-doc/git-for-each-ref.html


#>

# [Ex 1]: each
git for-each-ref --count=10 --sort='-*authordate'

# [Ex 2]: each multi lien format
$argFmt = @'
--format='From: %(*authorname) %(*authoremail)
Subject: %(*subject)
Date: %(*authordate)
Ref: %(*refname)

%(*body)
'@
git for-each-ref --count=10 --sort='-*authordate' @argFmt 'refs/tags'


# [Ex 3]: each on: 'refs/heads'
git for-each-ref --shell --format="ref=%(refname)" 'refs/heads'

# [Ex 4]: each on: 'refs/tags'
git for-each-ref --shell --format="ref=%(refname)" 'refs/tags'
