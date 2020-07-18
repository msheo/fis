//COMMON VARIABLE
TYPE = "dev"	// Choose one of [dev,qa,prd]
OCP_SERVICE_PJT_NAME = "fis-${TYPE}"
OCP_CICD_PJT_NAME = "fis-jenkins"

//SERVICE_INFO VARIABLE
SERVICE_NAME = "oz80"
APP_NAME = "${SERVICE_NAME}-app"
WAR_NAME = "${SERVICE_NAME}.war"
TARGET_PORT = "8080"
PORT = "8080"

//TOMCAT VARIABLE
TOMCAT_BASE_IMAGE = "tomcat"
TOMCAT_IMAGE_TAG = "8.5.57-jdk8-openjdk"
APM_INSTALL_YN = "N"	// Choose onf of [Y,N]

//GIT VARIABLE
USER = "msheo"
CREDENTIAL_ID = "TBD"	// Jenkins Credential Id
SOLUTION_WAR_GIT_URL = "http://${USER}@210.93.173.142/fis/oz80.git"
SOLUTION_WAR_GIT_BRANCH = "develop"

//////////////////////////////////////////////////////////
//     PIPELINE START, NEVER CHANGE ANY SCRIPT BELOW    //
//////////////////////////////////////////////////////////

node {
	//SOURCE CODE CLONE
    stage('solution-clone') {
		git url: "${SOLUTION_WAR_GIT_URL}", branch: "${SOLUTION_WAR_GIT_BRANCH}", credentialsId: "${CREDENTIAL_ID}"
    }
	
	//IMAGE BUILD STAGE
    stage('image-build') {
        runDockerBuild("${TYPE}", "${APM_INSTALL_YN}")
    }

	//DEPLOY BUILT IMAGE
    stage('image-deploy') {
        runDeploy("${TYPE}")
    }
}

void runDockerBuild(type, installApm) {
	def bcCount = sh(script: "oc get bc -n ${OCP_CICD_PJT_NAME} | awk '{print \$1}' | grep -x ${type}-${APP_NAME} | wc -l", returnStdout: true).trim()
	sh "echo ${bcCount}"
	def buildShell = "oc start-build bc/${type}-${APP_NAME} --from-dir='./' -w -n ${OCP_CICD_PJT_NAME}"
	
	// Config settings to be defined, maybe it needs to be set by Dockerfile, not here
	dir("oz-config") {
		sh "cp .... ...."
	}
	
	if(bcCount != "0") {
		println("Already BuildConfig Created, Start Build")
		sh "${buildShell}"
	}
	else {
		println("Create BuildConfig");
		def isCount = sh(script: "oc get is  -n ${OCP_CICD_PJT_NAME} | awk '{print \$1}' | grep -x ${TOMCAT_BASE_IMAGE} | wc -l", returnStdout: true).trim()
		print("${isCount}")
		if(isCount != "0") {
			sh "echo BuildConfig Tomcat Base Image"
			sh "cat ./Dockerfile | oc new-build --name ${type}-${APP_NAME} --dockerfile='-' --image-stream=\"${OCP_CICD_PJT_NAME}/${TOMCAT_BASE_IMAGE}:${TOMCAT_IMAGE_TAG}\" -n ${OCP_CICD_PJT_NAME}"
		}
		else {
			sh "echo BuildConfig"
			sh "cat ./Dockerfile | oc new-build --name ${type}-${APP_NAME} --dockerfile='-' -n ${OCP_CICD_PJT_NAME}"
		}
		
		sh "${buildShell}"
	}
	
}

void runDeploy(type) {
    def dcCountCmd = "oc get dc --namespace=${OCP_SERVICE_PJT_NAME} | grep ${APP_NAME} | wc -l"
    def dcCount = sh(script: "${dcCountCmd}", returnStdout: true).trim();
	
	if(dcCount =="0") {
		sh "oc new-app Tomcat-Template.yaml -p IMAGE_NAME=${type}-${APP_NAME} -p APPLICATION_NAME=${APP_NAME} -p CICD_NAME=${OCP_CICD_PJT_NAME} -p PORT=${PORT} -p TARGET_PORT=${TARGET_PORT} --namespace='${OCP_SERVICE_PJT_NAME}'"
		sh "oc rollout latest dc/${APP_NAME} --namespace='${OCP_SERVICE_PJT_NAME}'"
		//sh "oc expose svc/${APP_NAME} --port=${PORT} --namespace=\"${OCP_SERVICE_PJT_NAME}\""
		sh "oc rollout status dc/${APP_NAME} -w --namespace=\"${OCP_SERVICE_PJT_NAME}\""      
	}
	else {
		sh "oc rollout latest dc/${APP_NAME} --namespace='${OCP_SERVICE_PJT_NAME}'"
		sh "oc rollout status dc/${APP_NAME} -w --namespace=\"${OCP_SERVICE_PJT_NAME}\""
	}
}