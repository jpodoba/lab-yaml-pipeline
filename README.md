### Fully Functional YAML Pipeline for Azure DevOps

---

Azure DevOps is Micrososft's native solution which enables end-to-end software delivery. Yes, this includes the CI/CD capability with number of great features to go hand-in-hand for a comprehensive process.

YAML Pipelines brought in the Configuration as Code aspect to pipelines as all the pipelines (CI/CD) can be version controlled. 

This repository covers a YAML pipeline which includes;

- End-to-end CD/CD
- Infrastucture as Code Orchestration
- Security/Approvals
- Everything as Code

This repository holds sample pipelines which caters the following scenarios. 

#### Scenarios Covered

```
Build 
| * Infrastructure
| * Application


Build 
| * Infrastructure
| * Application
|
|-> develop
|      |
|      |-> Deploy DEV (Primary Region)
|      |     * Primary Region
|      |
|      |-> Deploy QA (Primary Region)
|      |     * Primary Region


Build 
| * Infrastructure
| * Application
|
|-> develop
|      |
|      |-> Deploy DEV (Primary Region)
|      |     * Primary Region
|      |
|      |-> Deploy QA (Primary Region)
|      |     * Primary Region
|
|-> master
|      |
|      |-> Deploy UAT
|      |     * Primary Region
|      |
|      |-> Deploy STG
|      |     * Primary Region
|      |
|      |-> Deploy PROD
|      |     * Primary Region
|      |     * Secondary Region

```

### Build Status

#### Build Only - without nested [build-core.yml](build-core.yml) 

| Branch    |                                                                                               Status                                                                                               |
| --------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| `master`  |  [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Only?branchName=master)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=23&branchName=master)  |
| `develop` | [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Only?branchName=develop)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=23&branchName=develop) |


#### Build Only [build.yml](build.yml) 

| Branch    |                                                                                               Status                                                                                               |
| --------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| `master`  |  [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Only?branchName=master)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=23&branchName=master)  |
| `develop` | [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Only?branchName=develop)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=23&branchName=develop) |

#### Build > Deploy `DEV` - [build-dev.yml](build-dev.yml) 

| Branch    |                                                                                                Status                                                                                                |
| --------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| `master`  |  [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Deploy?branchName=master)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=22&branchName=master)  |
| `develop` | [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Deploy?branchName=develop)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=22&branchName=develop) |

#### Build > Deply `Multiple Environments` - [azure-pipelines.yml](azure-pipelines.yml) 

| Branch    |                                                                                                     Status                                                                                                      |
| --------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| `master`  |  [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Deplo-Multi-Stage?branchName=master)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=20&branchName=master)  |
| `develop` | [![Build Status](https://dev.azure.com/hotbee/Labs/_apis/build/status/Lab-YAML-Build-Deplo-Multi-Stage?branchName=develop)](https://dev.azure.com/hotbee/Labs/_build/latest?definitionId=20&branchName=develop) |