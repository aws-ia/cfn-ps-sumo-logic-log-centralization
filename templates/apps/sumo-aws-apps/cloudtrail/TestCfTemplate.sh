#!/bin/bash

export AWS_REGION="us-east-1"
export AWS_PROFILE="default"
# App to test
export AppTemplateName="cloudtrail"
export AppName="cloudtrail"
export InstallTypes=("all")

for InstallType in "${InstallTypes[@]}"
do
    export CloudTrailLogsBucketName="${AppName}-${InstallType}-qwerty"
    export QSS3BucketName="sumologiclambdahelper-2-us-east-1"
    export QSS3BucketRegion="us-east-1"

    if [[ "${InstallType}" == "all" ]]
    then
        export InstallCloudTrailApp="Yes"
        export InstallPCICloudTrailApp="Yes"
        export InstallCISFoundationApp="Yes"
        export InstallCloudTrailMonitoringAnalyticsApp="Yes"
        export InstallCloudTrailSecOpsApp="Yes"
        export CreateCloudTrailBucket="Yes"
        export CreateCloudTrailLogSource="Yes"
    elif [[ "${InstallType}" == "onlycloudtrailapp" ]]
    then
        export InstallCloudTrailApp="Yes"
        export InstallPCICloudTrailApp="No"
        export InstallCISFoundationApp="No"
        export InstallCloudTrailMonitoringAnalyticsApp="No"
        export InstallCloudTrailSecOpsApp="No"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="No"
    elif [[ "${InstallType}" == "onlymonitoringanalyticscloudtrailapp" ]]
    then
        export InstallCloudTrailApp="No"
        export InstallPCICloudTrailApp="No"
        export InstallCISFoundationApp="No"
        export InstallCloudTrailMonitoringAnalyticsApp="Yes"
        export InstallCloudTrailSecOpsApp="No"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="No"
    elif [[ "${InstallType}" == "onlysecopscloudtrailapp" ]]
    then
        export InstallCloudTrailApp="No"
        export InstallPCICloudTrailApp="No"
        export InstallCISFoundationApp="No"
        export InstallCloudTrailMonitoringAnalyticsApp="No"
        export InstallCloudTrailSecOpsApp="Yes"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="No"
    elif [[ "${InstallType}" == "onlypcicloudtrailapp" ]]
    then
        export InstallCloudTrailApp="No"
        export InstallPCICloudTrailApp="Yes"
        export InstallCISFoundationApp="No"
        export InstallCloudTrailMonitoringAnalyticsApp="No"
        export InstallCloudTrailSecOpsApp="No"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="No"
    elif [[ "${InstallType}" == "onlycisfoundationapp" ]]
    then
        export InstallCloudTrailApp="No"
        export InstallPCICloudTrailApp="No"
        export InstallCISFoundationApp="Yes"
        export InstallCloudTrailMonitoringAnalyticsApp="No"
        export InstallCloudTrailSecOpsApp="No"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="No"
    elif [[ "${InstallType}" == "appexistingS3" ]]
    then
        export InstallCloudTrailApp="Yes"
        export InstallPCICloudTrailApp="Yes"
        export InstallCISFoundationApp="Yes"
        export InstallCloudTrailMonitoringAnalyticsApp="Yes"
        export InstallCloudTrailSecOpsApp="Yes"
        export CreateCloudTrailBucket="No"
        export CreateCloudTrailLogSource="Yes"
        export CloudTrailLogsBucketName="lambda-all-randmomstring"
    elif [[ "${InstallType}" == "onlysource" ]]
    then
        export InstallCloudTrailApp="No"
        export InstallPCICloudTrailApp="No"
        export InstallCISFoundationApp="No"
        export InstallCloudTrailMonitoringAnalyticsApp="No"
        export InstallCloudTrailSecOpsApp="No"
        export CreateCloudTrailBucket="Yes"
        export CreateCloudTrailLogSource="Yes"
    else
        echo "No Choice"
    fi

    # Export Sumo Properties
    export SumoAccessID=""
    export SumoAccessKey=""
    export SumoOrganizationId=""
    export SumoDeployment="us2"
    export RemoveSumoResourcesOnDeleteStack=true

    # Export Collector Name
    export CollectorName="AWS-Sourabh-Collector-${AppName}-${InstallType}"

    # Export CloudTrail Logs Details
    export CloudTrailBucketPathExpression="*"
    export CloudTrailLogsSourceName="AWS-${AppName}-${InstallType}-Source"
    export CloudTrailLogsSourceCategoryName="AWS/${AppName}/${InstallType}/Logs"

    export template_file="${AppTemplateName}.template.yaml"

    aws cloudformation deploy --profile ${AWS_PROFILE} --region ${AWS_REGION} --template-file ./cloudtrail.template.yaml \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name "${AppName}-${InstallType}" \
    --parameter-overrides SumoDeployment="${SumoDeployment}" SumoAccessID="${SumoAccessID}" SumoAccessKey="${SumoAccessKey}" \
    SumoOrganizationId="${SumoOrganizationId}" RemoveSumoResourcesOnDeleteStack="${RemoveSumoResourcesOnDeleteStack}" \
    CollectorName="${CollectorName}" CloudTrailLogsBucketName="${CloudTrailLogsBucketName}" CloudTrailBucketPathExpression="${CloudTrailBucketPathExpression}" \
    CloudTrailLogsSourceName="${CloudTrailLogsSourceName}" CloudTrailLogsSourceCategoryName="${CloudTrailLogsSourceCategoryName}" \
    CreateCloudTrailBucket="${CreateCloudTrailBucket}" CreateCloudTrailLogSource="${CreateCloudTrailLogSource}" \
    QSS3BucketName="${QSS3BucketName}" QSS3BucketRegion="${QSS3BucketRegion}" InstallCloudTrailApp="${InstallCloudTrailApp}" \
    InstallPCICloudTrailApp="${InstallPCICloudTrailApp}" InstallCISFoundationApp="${InstallCISFoundationApp}" \
    InstallCloudTrailMonitoringAnalyticsApp="${InstallCloudTrailMonitoringAnalyticsApp}" \
    InstallCloudTrailSecOpsApp="${InstallCloudTrailSecOpsApp}"

done

echo "All Installation Complete for ${AppName}"