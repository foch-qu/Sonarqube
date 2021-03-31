# Sonarqube

#### - Sonarqube-Server IP: 192.168.0.212
###### - Port: 9000
###### - Username: admin
###### - Passwd:   passwd
### How to Run Server 

Run  `/home/jenkins/sonarqube/startSonarqubeServer.sh` to start Sonarqube Server

Run `sudo docker restart pgdb sq` to RESTART DB & SONARTQUBE SERVER

### If Sonarqube Server always exited
### Please input " sudo sysctl -a | grep vm.max_map_count " in terminal，if show the result is "vm.max_map_count = 65530"
### Input " sudo sysctl -w vm.max_map_count=262144 "  in terminal to change vm.max_map_count
### Then restart `sudo docker restart sq` again

* * *

### How to scan JAVA
##### Add plugins after buildscript in project root build.gradle
* `
plugins {
  id "org.sonarqube" version "3.0"
}
`

* `Sonar-Qube Properties`  
sonarqube {  
    properties {  
        property "sonar.projectVersion", "1.0"  
        property "sonar.projectName", "Name"  
        property "sonar.projectKey", "Key"  
        property "sonar.host.url", "http://192.168.0.212:9000/"  
        property "sonar.login", "passwd"  
        property "sonar.language", "java"  
        property "sonar.java.binaries", "./app/src/main/java"  
        property "sonar.java.coveragePlugin", "jacoco"  
        property "sonar.coverage.jacoco.xmlReportPaths", "${rootProject.projectDir}/app/build/reports/jacoco/jacocoCoverageTestReport/jacocoCoverageTestReport.xml"
    }  
}

##### Add plugins on app/build.gradle second line or top
* `
apply from: '../jacoco-report.gradle'
`

* `Add coverageDebug in buildTypes{}`  
coverageDebug {  
        minifyEnabled false  
        testCoverageEnabled true  
    }  


* Then Run
`
./gradlew build jacocoCoverageTestReport sonarqube
-Dsonar.projectKey=java
-Dsonar.projectName=java
-Dsonar.host.url=http://192.168.0.212:9000
-Dsonar.login=token
`

#### If already set sonarqube properties，run ` ./gradlew build jacocoCoverageTestReport sonarqube`
##### -Dsonar.projectKey & -Dsonar.projectName 一致最好
##### Catch Java project name
* `- id=$(./gradlew projects |grep "Root project" | sed -n '2p' | awk '{print $3}' | sed $'s/\'//g')`  
* `- echo "More Detail Info http://192.168.0.212:9000/dashboard?id=${id}"`
* `Add in  .gitlab.yml's script`
* * *

### How to scan C
##### Please create a new project for it, named `-Dsonar.projectKey` such as C, PYTOHN
##### If new project is C, you must config the project first, in setting, select C++(Community)
##### In Source files suffixes & Header files suffixes, del the `.c` and `.h`
* `
  sonar-scanner
  -Dsonar.projectKey=c
  -Dsonar.sources=src
  -Dsonar.host.url=http://192.168.0.212:9000
  -Dsonar.login=token
  `
### e.g:  
* `cppcheck --enable=all --xml-version=2  -j 2 ./ 2>cppcheck.xml`  
* `sonar-scanner -Dsonar.projectKey=TDA4  -Dsonar.projectName=Desay/TDA4  -Dsonar.sources=avplayer,ci_dvr_player  -Dsonar.java.binaries=avplayer/CI_Android_Demo_Stream/*,avplayer/Samples/*  -Dsonar.host.url=http://192.168.0.212:9000  -Dsonar.login=token  -Dsonar.c.cppcheck.reportPath=cppcheck.xml`

#### Available languages:
* CSS => "css"
* Scala => "scala"
* C# => "cs"
* Java => "java"
* HTML => "web"
* JSP => "jsp"
* Flex => "flex"
* XML => "xml"
* VB.NET => "vbnet"
* C++ (Community) => "c++"
* Python => "py"
* C (Community) => "c"
* Go => "go"
* Kotlin => "kotlin"
* HTL => "htl"
* JavaScript => "js"
* TypeScript => "ts"
* Ruby => "ruby"
* PHP => "php"
* -Dsonar.language=c, py, java

### e.g
* https://www.sonarqube.org/
* https://zhuanlan.zhihu.com/p/139175875
