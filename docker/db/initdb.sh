#!/bin/bash
echo "******CREATING DOCKER DATABASE******"
gosu postgres postgres --single <<- EOSQL
   CREATE DATABASE sfm;
EOSQL
echo ""
echo "******DOCKER DATABASE CREATED******"
