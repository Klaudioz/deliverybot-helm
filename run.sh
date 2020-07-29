#!/bin/sh

WATCH="${HUGO_WATCH:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
HUGO_DESTINATION="${HUGO_DESTINATION:=/src}"
echo "HUGO_WATCH:" $WATCH
echo "HUGO_REFRESH_TIME:" $HUGO_REFRESH_TIME
echo "HUGO_THEME:" $HUGO_THEME
echo "HUGO_BASEURL" $HUGO_BASEURL
echo "ARGS" $@

HUGO=/usr/local/sbin/hugo
echo "Hugo path: $HUGO"

while [ true ]
do
    if [[ $HUGO_WATCH != 'false' ]]; then
	    echo "Watching..."
        $HUGO server --buildDrafts --watch=true --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --appendPort=false --disableKinds = ["home", "page", "section", "taxonomy", "taxonomyTerm"] --bind="0.0.0.0" --baseURL="/" "$@" || exit 1
    else
	    echo "Building one time..."
        $HUGO --source="/src" --theme="$HUGO_THEME" --baseURL="$HUGO_BASEURL" "$@" || exit 1
    fi

    if [[ $HUGO_REFRESH_TIME == -1 ]]; then
        exit 0
    fi
    echo "Sleeping for $HUGO_REFRESH_TIME seconds...."
    sleep $SLEEP
done
