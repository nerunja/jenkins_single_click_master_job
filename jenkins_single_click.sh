Jenkins_single_click


#!/bin/bash
gsheettabname="SevaRunTestRunDay2"
project_webstore="https://cicd-jenkins.myorg.com:8443/jenkins/view/job/WebStoreIntegrationTestOrderPlacement"
project_oms="https://cfs-jenkins.myorg.com:8443/job/OMS_Order_Processing"
project_store="https://cfs-jenkins.myorg.com:8443/job/QCoE_IntegrationTesting_Stores"
project_taxware="https://cfs-jenkins.myorg.com:8443/job/Taxware_Validations"
project_day1="https://cfs-jenkins.myorg.com:8443/job/Taxware_day1_validation"
project_day2report="https://cfs-jenkins.myorg.com:8443/job/Taxware_Day2_Validations"
project_day2prereqreport="https://cfs-jenkins.myorg.com:8443/job/OMS_Order_Processing_2"

param_webstore="{\"parameter\": [{\"name\":\"meta.filters\",\"value\":\"\"},{\"name\":\"EnvName\",\"value\":\"VDC-M297104874-25212-270 - ATG AE13\"},{\"name\":\"BROWSER\", \"value\":\"-Dbrowser=chrome -Dbrowser.version=60.0 -Dplatform.name=\\\"Windows 10\\\"\"},{\"name\":\"AdditionalMavenParameters\", \"value\":\"-Dstore.prod.ip=www-rel02.myorgecommerce.com -Dsuite.all=**/**IntegrationTestSuite.* -Dsuite.list=IntegrationTestSuite -Dstore.prod.http.port= -Dstore.prod.https.port= -Dfluentwait=true -Dstory.list=IntegrationTestingOrderCreationUsingAPI -Dgsheet.id=1UWPta1dNJAT3Xj0Mad5rStquZ1oEw_2BwoIHoeVMn-w -Dtestdata.gsheet=true -Dgsheet.name.testdata=SevaQA01 -Dgsheet.id.testdata=1-y69R3wyQ4mARs46h1qKa0dExsDPM9LW_IVEMbsj-go -Dseva.prod.ip=10.30.30.30 -Dkc.tokenized=true -Dseva.prod.ip.accservice=10.20.20.20 -Dseva.prod.sheetname=$gsheettabname -Dseva.prodcsc.ip=10.10.10.10 -Dseva.prod.sheetid=AWXYh204ytI3D6zjKDjr1zqU5VAidNjq_3eV6jL98NbM -Dgsheet.saveorder=true\"}]}"
param_oms="{\"parameter\": [{\"name\":\"TestGroup\",\"value\":\"OrderProcess\"},{\"name\":\"Environment\", \"value\":\"DEV_015\"},{\"name\":\"Sheetname\", \"value\":\"$gsheettabname\"}]}"
param_store="{\"parameter\": [{\"name\":\"testEnv\",\"value\":\"isp9921e\"},{\"name\":\"testGroup\", \"value\":\"Integration\"},{\"name\":\"omsEnv\", \"value\":\"DEV_015_CLOUD\"},{\"name\":\"sheetname\", \"value\":\"$gsheettabname\"}]}"
param_taxware="{\"parameter\":[{\"name\":\"lob\",\"value\":\"webstore\"}]}"
param_day1="{\"parameter\":[{\"name\":\"lob\",\"value\":\"webstore\"}]}"
param_day2report="{\"parameter\":[{\"name\":\"lob\",\"value\":\"webstore\"}]}"
param_project_day2prereqreport="{\"parameter\":[{\"name\":\"Branch\",\"value\":\"Seva_PreRequisites\"},{\"name\":\"lob\",\"value\":\"day2ws\"}]}"

user_webstore="jenkins_token_user_x:ad18150361b1ca2c207086232f3c2b58"
user_oms="jenkins_token_user_y:898f72a15b35e05835194df004f9cbd8"
user_store="jenkins_token_user_z:ad49bd2fd59227a9a85af134ed03206e"
user_taxware_day1="jenkins_token_user_a:0508ce47c1e9d1cb7ef48cb4cbb59eb9"
user_day2report="jenkins_token_user_b:b26f3d8d69f8e31464352f33588530a3"
user_project_day2prereqreport="jenkins_token_user_c:611d7f38569cf81407bfe6f3550cbeae"

echo "[INFO][($date)] --------------------------------------------------------------------"
echo "[INFO][($date)] -------------STARTED TRIGGERING JOB---------------------------------"
function start_job {
  nextBuildNumber=`curl -k -s $project/api/json --user $jenkins_token| grep -Po '"nextBuildNumber":\K\d+'`
  echo "[INFO] $(date) nextBuildNumber $nextBuildNumber"
  curl -k -X POST $project/build --user $jenkins_token --data-urlencode json="$param"
  echo "[INFO] Triggered jenkins job $project"
  result=`curl -k -s $project/$nextBuildNumber/api/json --user $jenkins_token| grep -Po '"result":\s*"\K\w+'`
  echo "[INFO] Waiting until build '$nextBuildNumber' is completed"
  echo "Build status '$result'"
  while [ "$result" = "" ]; do
      echo "[INFO] Sleeping 1 minute"
      sleep 1m
      result=`curl -k -s $project/$nextBuildNumber/api/json --user $jenkins_token| grep -Po '"result":\s*"\K\w+'`
      echo "[INFO] Build status '$result'"
  done
  echo "[INFO] Jenkins job execution completed for build $nextBuildNumber, build status: $result"
}

project="$project_webstore"
jenkins_token="$user_webstore"
param="$param_webstore"
start_job 

project="$project_oms"
jenkins_token="$user_oms"
param="$param_oms"
start_job 

project="$project_store"
jenkins_token="$user_store"
param="$param_store"
start_job 

echo "[INFO][($date)] -------------COMPLETED TRIGGERING JOBS--------------------------------"
echo "[INFO][($date)] ----------------------------------------------------------------------"

