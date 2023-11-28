#!/bin/sh
echo "CHECK WITH CFN-NAG-SCAN"
current_date=`date +"%Y_%m_%d_%s"`

output_cfn_nag_scan=output-checksecurity/cfn_nag_scan_${current_date}.txt
for dir in apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    cfn_nag_scan --input-path $dir -t ..*\.yaml >> ${output_cfn_nag_scan}
done

echo "CHECK WITH CFN-LINT"
output_cfn_lint=output-checksecurity/cfn_lint_${current_date}.txt
for dir in apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    cfn-lint  $dir/*.yaml >> ${output_cfn_lint}
done

echo "CHECK WITH Bridgecrew"
output_bridgecrew=output-checksecurity/bridgecrew_${current_date}.txt
for dir in apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    bridgecrew -f  $dir/*.yaml >> ${output_bridgecrew}
done