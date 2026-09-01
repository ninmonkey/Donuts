# [ex: 1]: Author, email, commit message
git.exe log --pretty=format:"%cd - %an <%ae> [%s]"
# [ex: 2]:  1 with color
git.exe log --pretty=format:"%C(yellow)%cd %C(cyan)%an %C(green)<%ae> %C(reset)%s"
