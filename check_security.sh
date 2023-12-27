#!/bin/bash
echo -e "Starting check securities\n1.cfn-nag\n2.cfn-lint\n3.bridgecrew\n4.All"
read -p "Enter your choice: " option
mkdir -p output-checksecurity
current_date=`date +"%Y_%m_%d_%s"`

output_cfn_nag_scan=output-checksecurity/cfn_nag_scan_${current_date}.txt
if [ $option -eq "1" ] || [ $option -eq "4" ]
then
echo "CHECK WITH CFN-NAG-SCAN"
for dir in templates/apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    cfn_nag_scan --input-path $dir -t ..*\.yaml >> ${output_cfn_nag_scan}
done
fi
if [ $option -eq "2" ] || [ $option -eq "4" ]
then
echo "CHECK WITH CFN-LINT"
output_cfn_lint=output-checksecurity/cfn_lint_${current_date}.txt
git clone https://github.com/aws-quickstart/qs-cfn-lint-rules.git
pip install -e qs-cfn-lint-rules
for dir in templates/apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    cfn-lint --ignore-checks W,E1019,E2521,E3002,E3005,E9101  -t $dir/*.yaml  -a qs-cfn-lint-rules/qs_cfn_lint_rules/ >> ${output_cfn_lint}
done
fi
if [ $option -eq "3" ] || [ $option -eq "4" ]
then
echo "CHECK WITH Bridgecrew"
output_bridgecrew=output-checksecurity/bridgecrew_${current_date}.txt
for dir in templates/apps/sumo-aws-apps/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo $dir
    bridgecrew -f  $dir/*.yaml >> ${output_bridgecrew}
done
fi