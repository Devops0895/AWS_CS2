#!/bin/bash

echo "s3_bucket_name = ${var.s3_bucket_name}"

#this script is for access the s3 buckets present in the appropriate account
aws s3 ${var.s3_bucket_name} ls