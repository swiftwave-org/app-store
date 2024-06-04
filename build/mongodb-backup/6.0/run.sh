#!/bin/bash

S3PATH="s3://$BUCKET/$BUCKET_PREFIX"

[[ ( -n "${ENDPOINT_URL}" ) ]] && ENDPOINT_STR=" --endpoint-url ${ENDPOINT_URL}"
[[ ( -n "${BUCKET_REGION}" ) ]] && REGION_STR=" --region ${BUCKET_REGION}"
[[ ( -n "${MONGODB_USER}" ) ]] && USER_STR=" --username ${MONGODB_USER}"
[[ ( -n "${MONGODB_PASS}" ) ]] && PASS_STR=" --password ${MONGODB_PASS}"
[[ ( -n "${MONGODB_DB}" ) ]] && DB_STR=" --db ${MONGODB_DB}"
[[ ( -n "${MONGODB_PORT}" ) ]] && PORT_STR=" --port ${MONGODB_PORT}"
[[ ( -n "${MONGODB_HOST}" ) ]] && HOST_STR=" --host ${MONGODB_HOST}"

# Export AWS Credentials into env file for cron job
printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' | grep -E "^export AWS" > /root/project_env.sh
chmod +x /root/project_env.sh

echo "=> Creating backup script"
rm -f /backup.sh
cat <<EOF >> /backup.sh
#!/bin/bash
TIMESTAMP=\`/bin/date +"%Y%m%dT%H%M%S"\`
BACKUP_NAME=\${TIMESTAMP}.dump.gz
S3BACKUP=${S3PATH}\${BACKUP_NAME}

aws configure set default.s3.signature_version s3v4
echo "=> Backup started"
if mongodump ${HOST_STR}${PORT_STR}${USER_STR}${PASS_STR}${DB_STR} --archive=\${BACKUP_NAME} --gzip && aws s3 cp \${BACKUP_NAME} \${S3BACKUP} ${REGION_STR} ${ENDPOINT_STR} && rm \${BACKUP_NAME} ;then
    echo "   > Backup succeeded"
else
    echo "   > Backup failed"
fi
echo "=> Done"
EOF
chmod +x /backup.sh
echo "=> Backup script created"

ln -s /backup.sh /usr/bin/backup

echo "=> Creating a backup on startup"
/backup.sh


echo "${CRON_TIME} . /root/project_env.sh; /backup.sh" > /crontab.conf
crontab  /crontab.conf
echo "=> Running cron job"
cron -f