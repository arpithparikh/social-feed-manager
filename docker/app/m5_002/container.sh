#!/bin/bash

docker run -d --name "sfm_app" \
    --env-file ./env.list \
    --link sfm_db:db \
    -p 8000:80 \
    gwul/sfm_app
