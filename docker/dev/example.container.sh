#!/bin/bash

docker run -d --name "sfm_dev" \
    --env-file ./env.list \
    --link sfm_db:db \
    -p 8000:80 \
    -v ~/Data/sfm/social-feed-manager:/opt/social-feed-manager \
    gwul/sfm_dev
