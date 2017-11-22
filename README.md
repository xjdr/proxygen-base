Proxygen Base
=============

This repo builds the base image for developing folly, wangle or proxygen based
projects. This docker image should not be deployed to production, as it contains
build tooling. Instead, you should create a statically linked binary and ship
that in the prod-base docker file. 
