import groovy.json.JsonSlurperClassic
properties([[$class: 'GitLabConnectionProperty', gitLabConnection: 'NAS']])

def updateStatus(String status) {
    updateGitlabCommitStatus(state: status);
}


def dot(String command) {
    bat """
        call .${command}
        exit /b %ERRORLEVEL%
    """
}

def Object getGitVersion() {
	jsonText = bat(returnStdout: true, script: '@gitversion')
	println "${jsonText}"
	return new JsonSlurperClassic().parseText(jsonText)  			
}

def String getPackageFtpLinkText(String link, String text) {
	def projectName = env.JOB_NAME.substring(0, env.JOB_NAME.indexOf("/")).toLowerCase() 
	def ftpUri = "ftp://nas/builds/${projectName}/" + link
	return hudson.console.ModelHyperlinkNote.encodeTo(ftpUri, text);
}

def void getPackageLinks(Object gitVersion) {
	branch = getPackageFtpLinkText("${gitVersion.BranchName}", gitVersion.BranchName)
	version = getPackageFtpLinkText("${gitVersion.BranchName}/${gitVersion.InformationalVersion}", gitVersion.InformationalVersion)	
	println "Branch:    ${branch}\nVersion:   ${version}\n          "
}


node("matt10") {
    
    try {
               
        def gitVersion
        updateStatus('running')

        stage('Init') {
            milestone Integer.parseInt(env.BUILD_ID)
            deleteDir()  
        }
        
        stage('Checkout') {
            milestone()
            checkout scm
            gitVersion = getGitVersion();
            currentBuild.description = gitVersion.InformationalVersion
        }

        stage('Restore') {
            milestone()
            dot('restore')
        }

        stage('Build') {
            milestone()
            dot('build')
        }

        stage('Test') {
            milestone()
            dot('test')
        }

        stage('Pack') {
            milestone()
            dot('pack')
        }
                
        stage('Cleanup') {
            milestone()
            deleteDir()                
        } 

        stage ('Package') {
            getPackageLinks(gitVersion)	
        }
       
        updateStatus('success')
    }
    catch (e) {
        updateStatus('failed')
        throw e
    }
}
