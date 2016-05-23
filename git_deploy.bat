@echo on
REM ------------------------------------------------------------
REM Usage: git_deploy.bat <commit_comment>
REM ------------------------------------------------------------


SET git_user=fizalihsan
SET git_pwd=capsicum8213
SET comment=%1

rake generate
git add .
git commit -am %comment%
git push origin source
