git add .
message=`date +%Y-%m-%d-%H-%M`

while getopts m: opt
do
   case $opt in
        m)
           message=$OPTARG
           ;;
        ?)
           echo "Usage: args [-m]"
           echo "-m means message"
           echo "exit"
           exit
           ;;
   esac
done

git commit -m "$message"
git push origin gh-pages
