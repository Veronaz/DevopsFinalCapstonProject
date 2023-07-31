AWS_DEFAULT_REGION=us-east-2
instanceId=$(aws ec2 describe-instances \
                --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=Jenkins" \
                --region us-east-2 \
                --query "Reservations[0].Instances[0].InstanceId" \
                --output text )
echo Portforwarding Jenkins instance $instanceId
# Mac os install session manager plugin 
#curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg" -o "session-manager-plugin.pkg"
# sudo installer -pkg session-manager-plugin.pkg -target /
# sudo ln -s /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin
aws ssm start-session \
    --target $instanceId \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["8080"], "localPortNumber":["8080"]}' \
    --region us-east-2