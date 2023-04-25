###Overview###
Vagrant is used for  creating virtual machine using Virtualbox provider and install ansible on master's host. 
Parameters allow to increase the amount of nodes if needed.
Requirement for jenkins: (Minimum hardware requirements - can use as we need just run small project)
256 MB of RAM
1 GB of drive space
In current configuration Vagrantfile creates following instances:
1. Master node (almaLinux8).
2. Windows slave (windows server 2016).
3. Linux slave (almaLinux8).
The scripts that install ansible on master node and configure access to slave nodes are included in Vagrantfile.
Ansible is used for the jenkins master and two slaves installation and also for connection agents to jenkins.
The only things that should be done through the user interface is generating token and plugins installation.
Plugins that should be installed beyond the default installation:
Conditional BuildStep;
Parameterized Trigger plugin;
PowerShell plugin.

###Workflow implementation###
-----------------------
Three jobs are created by Jenkins Job Builder:
1. run_parameters_job - job that run on master node, clone the repo and run required job according to "os" parameter value.
scm specified for this job in order to avoid installation of Git to slave nodes. The "pollscm" method for triggereng is choosen instead of the GitHub webhooks because of absence of whhite ip on test host. 
2. fetch_windows_parameters - job that run on windows node, run shell script for collect required parameters to file and publish it as job artifacts;
3. fetch_linux_parameters - job that run on linux node, run powershell script for collect required parameters to file and publish it as job artifacts;

###Instruction for deploy on Windows machine:###
------------------------------------------
Pre-requirements:
Virtualbox, Vagrant installed
1. Creation virtual machines with ansible installed: 
cd .\jenkins-vms
vagrant up
2. Copy ansible, jenkins-job-builder, create _agents.sh to master 
vagrant upload
3. Run playbook for jenkins installation on master (inside ansible directory)
vagrant ssh master
cd to ansible
ansible-playbook -i inventory.yml install-jenkins-playbook.yml
4. Go to browser on http://192.168.0.100:8080/, 
Chose plugins for installation (Conditional BuildStep, Parameterized Trigger plugin, PowerShell plugin)
Create "jenkins" user and token 
5. Create agents using RestAPI: 
put token and jenkins crumb to "crete_agents.sh" script and run it
6. Configure nodes for being jenkins agents:
ansible-playbook -i inventory.yml install-linux-slave.yml
ssh to linux1
cd /home/jenkins && java -jar agent.jar -jnlpUrl http://192.168.0.100:8080/manage/computer/linux1/jenkins-agent.jnlp -secret ./LinuxSecret.txt -workDir "/home/jenkins"
ansible-playbook -i inventory.yml install-windows-slave.yml
Connect to windows1
in powershell run:
cd c:\jenkins
java -jar agent.jar -jnlpUrl http://192.168.0.100:8080/manage/computer/windows/jenkins-agent.jnlp - secret .\WindowsSecret.txt -workDir "c:\jenkins"
7. Create jobs using Jenkins Job Builder tool:
Put jenkins token to jenkins-job-builder/jenkins_jobs.ini
cd jenkins-job-builder
jenkins-jobs --conf ./jenkins_jobs.ini update jobs

####TODO:####

1. Try to use common job_template for creating fetch_windows_parameters and fetch_linux_parameters jobs.
2. Add agent.jar as a windows service and systemd service to windows and linux playbooks accordingly.
3. Put variables to separate files.



