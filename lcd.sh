# Lazy Change Directory
#
# derived from some old code from spoonm, https://github.com/twerth/bashmarks and my own modifications.

bookmarks_file=~/.bookmarks

# create bookmark storage file.
if [[ ! -f $bookmarks_file ]]; then
    touch $bookmarks_file
fi


# add a bookmark. ######################################################################################################
acd ()
{
    bookmark_name=$1

    # no bookmark name specified.
    if [[ -z $bookmark_name ]]; then
        echo "you didn't specify a bookmark name sir."

    else
        # store the bookmark as name|path.
        bookmark="$bookmark_name|`pwd`"

        # ensure bookmark doesn't already exist.
        if [[ -z `grep "$bookmark_name|" $bookmarks_file` ]]; then
            echo $bookmark >> $bookmarks_file
            echo "bookmark saved: $bookmark_name"

        else
            echo "bookmark already exists by that name."
        fi
    fi
}


# delete a bookmark. ###################################################################################################
dcd ()
{
    bookmark_name=$1

    # no bookmark name specified.
    if [[ -z $bookmark_name ]]; then
        echo "you didn't specify a bookmark name sir."

    else
        bookmark=`grep "$bookmark_name|" "$bookmarks_file"`

        # no match.
        if [[ -z $bookmark ]]; then
            echo "no bookmark by that name sir."

        else
            cat $bookmarks_file | grep -v "$bookmark_name|" > $bookmarks_file
            echo "bookmark deleted: $bookmark_name"
        fi
    fi
}


# print bookmarks. #####################################################################################################
pcd ()
{
    cat $bookmarks_file | sort | awk '{ printf "%-20s%-40s%s\n",$1,$2,$3}' FS=\|
}


# lazy change directory. ###############################################################################################
lcd()
{
    bookmark_name=$1

    bookmark=`grep "$bookmark_name|" "$bookmarks_file"`

    if [[ -z $bookmark ]]; then
        echo "no bookmark by that name sir."
    else
        dir=`echo "$bookmark|" | cut -d\| -f2`
        cd "$dir"
    fi
}

# bash completion. #####################################################################################################
_go_complete()
{
    cat $bookmarks_file | cut -d\| -f1 | grep "$2.*"
}

complete -C _go_complete -o default lcd
