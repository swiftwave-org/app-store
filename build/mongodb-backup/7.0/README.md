# mongodb-backup-s3

This is a simplified version of the mongodb-backup-s3 fork https://github.com/kevoj/mongodb-backup-s3.

Current image supports only `backup` of database.

---

## Example AWS IAM policy

This policy contains the required permissions for this container to operate. Replace the
`YOUR-BUCKET-HERE` placeholder with your bucket name.
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR-BUCKET-HERE",
        "arn:aws:s3:::YOUR-BUCKET-HERE/*"
      ]
    }
  ]
}
```

## Parameters

`AWS_ACCESS_KEY_ID` - your aws access key id (for your s3 bucket)

`AWS_SECRET_ACCESS_KEY`: - your aws secret access key (for your s3 bucket)

`BUCKET`: - your s3 bucket

`BUCKET_REGION`: - your s3 bucket' region (eg `us-east-2` for Ohio). Optional. Add if you get an error `A client error (PermanentRedirect)`

`ENDPOINT_URL`: - your custom S3 endpoint (eg `https://radosgw.example.com` )

`BUCKET_PREFIX`: - name of folder or path to put backups (eg `myapp/db_backups/`). defaults to root of bucket.

`MONGODB_HOST` - the host/ip of your mongodb database

`MONGODB_PORT` - the port number of your mongodb database

`MONGODB_USER` - the username of your mongodb database. I

`MONGODB_PASS` - the password of your mongodb database

`MONGODB_DB` - the database name to dump. If not specified, it will dump all the databases

`CRON_TIME` - the interval of cron job to run mongodump. `0 3 * * *` by default, which is every day at 03:00hrs.

`INIT_BACKUP` - if set, create a backup when the container launched



## Acknowledgements

Fork tree
```
https://github.com/halvves/mongodb-backup-s3
 └─ https://github.com/deenoize/mongodb-backup-s3
    └─ https://github.com/chobostar/mongodb-backup-s3
       └─ https://github.com/zhonghuiwen/mongodb-backup-s3
          └─ https://github.com/kevoj/mongodb-backup-s3
            └─ this fork
```