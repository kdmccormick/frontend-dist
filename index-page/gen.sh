#!/bin/bash

frontend_item_tpl=$(cat index-page/frontend-item.tpl.html)
frontend_list=$(./foreach-frontend.sh eval echo \""$frontend_item_tpl"\")

index_page_tpl=$(cat index-page/index.tpl.html)
index_page=$(FRONTEND_LIST="$frontend_list" eval echo \""$index_page_tpl"\")

echo "$index_page" > index-page/index.html
