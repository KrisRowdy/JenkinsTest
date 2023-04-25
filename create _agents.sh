#!/bin/bash
user="jenkins"
token="11928d1a1bd7d0bb19295a0b76d56fa17b"
crumb="2e9bbc32f45cf3b8c15493491681e52ded65624e003877640ca9ee1330fc9636"
jenkins_host="192.168.0.100:8080"
node_name="linux"
curl -L -s -o /dev/null -w "%{http_code}" -u "${user}:${token}" -H "Content-Type:application/x-www-form-urlencoded" -H "Jenkins-Crumb:${crumb}" -X POST -d 'json={"name": "${node_name}", "nodeDescription": "", "numExecutors": "1", "remoteFS": "/home/jenkins", "labelString": "${label}", "mode": "NORMAL", "": ["hudson.slaves.JNLPLauncher", "0"], "launcher": {"stapler-class": "hudson.slaves.JNLPLauncher", "$class": "hudson.slaves.JNLPLauncher", "workDirSettings": {"disabled": false, "workDirPath": "", "internalDir": "remoting", "failIfWorkDirIsMissing": false}, "webSocket": false, "tunnel": ""}, "retentionStrategy": {"stapler-class": "hudson.slaves.RetentionStrategy$Always", "$class": "hudson.slaves.RetentionStrategy$Always"}, "nodeProperties": {"stapler-class-bag": "true"}, "Submit": "", "Jenkins-Crumb": "${crumb}"}' "http://${jenkins_host}/computer/doCreateItem?name=${node_name}&type=hudson.slaves.DumbSlave";
echo "$(curl -L -s -u "${user}:${token}" -H "Jenkins-Crumb:${crumb}" -X GET "http://${jenkins_host}/computer/${node_name}/slave-agent.jnlp" | sed 's/.*<application-desc><argument>\([a-z0-9]*\).*/\1/')">/tmp/LinuxSecret.txt
node_name="windows"
curl -L -s -o /dev/null -w "%{http_code}" -u "${user}:${token}" -H "Content-Type:application/x-www-form-urlencoded" -H "Jenkins-Crumb:${crumb}" -X POST -d 'json={"name": "${node_name}", "nodeDescription": "", "numExecutors": "1", "remoteFS": "c:\jenkins", "labelString": "${label}", "mode": "NORMAL", "": ["hudson.slaves.JNLPLauncher", "0"], "launcher": {"stapler-class": "hudson.slaves.JNLPLauncher", "$class": "hudson.slaves.JNLPLauncher", "workDirSettings": {"disabled": false, "workDirPath": "", "internalDir": "remoting", "failIfWorkDirIsMissing": false}, "webSocket": false, "tunnel": ""}, "retentionStrategy": {"stapler-class": "hudson.slaves.RetentionStrategy$Always", "$class": "hudson.slaves.RetentionStrategy$Always"}, "nodeProperties": {"stapler-class-bag": "true"}, "Submit": "", "Jenkins-Crumb": "${crumb}"}' "http://${jenkins_host}/computer/doCreateItem?name=${node_name}&type=hudson.slaves.DumbSlave";
echo "$(curl -L -s -u "${user}:${token}" -H "Jenkins-Crumb:${crumb}" -X GET "http://${jenkins_host}/computer/${node_name}/slave-agent.jnlp" | sed 's/.*<application-desc><argument>\([a-z0-9]*\).*/\1/')">/tmp/WindowsSecret.txt
curl -sO http://${jenkins_host}/jnlpJars/agent.jar --output /tmp


