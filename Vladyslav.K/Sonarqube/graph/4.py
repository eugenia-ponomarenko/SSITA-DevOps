from diagrams.custom import Custom
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.vcs import Github
from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.database import Postgresql
from diagrams.saas.chat import Slack

graph_attr = {
    "splines":"true#",
    "fontsize":"30",
    "forcelabels":"true"
}
jenkinsAgent_attr = {
    "splines":"spline",
    "fontsize":"15",
    "forcelabels":"true"
}
edge_attr = {
    "minlen":"2.0",
    "penwidth":"3.0"
}
legend_attr = {
    "fontsize":"30",
    "minlen":"2.0",
    "penwidth":"4.0",
    "bgcolor":"white"
}
with Diagram("SonarQube", show=True, direction="LR", graph_attr=graph_attr, edge_attr=edge_attr):
    jenkins = Jenkins("Jenkins", fontsize="15")
    github = Github("Github repository", fontsize="15")
    developer = Custom("Developer", "./customimages/dev.jpg")
    sonarqube = Custom("", "./customimages/SonarQube logo black 512 px.png")
    nextJenkinsJob = Custom("Next job", "./customimages/jenkins-job.png")
    slack = Slack("Slack", fontsize="15")

    with Cluster("Jenkins Agent", graph_attr=jenkinsAgent_attr):
        postgresql = Postgresql("Postgresql with test DB", fontsize="15")
        maven = Custom("", "./customimages/maven.png")

    developer >> Edge(color="black", style="bold", label="Push", fontsize="15") >> github
    github >> Edge(color="black", style="bold", label="Webhook", fontsize="15") >> jenkins
    jenkins >> Edge(color="black", style="bold", label="Start Job", fontsize="15") >> maven
    maven >> Edge(color="dodgerblue2", style="bold", label="Connection for testing", fontsize="15") << postgresql
    maven >> Edge(color="dodgerblue3", style="bold", label="Send report", fontsize="15") >> sonarqube
    sonarqube >> Edge(color="dodgerblue1", style="bold", label="QualityGate webhook", fontsize="15") >> maven
    maven >> Edge(color="darkorange1", style="bold", label="Job result", fontsize="15") >> jenkins
    jenkins >> Edge(color="green2", style="bold", label="If job result 'SUCCESS'", fontsize="15") >> nextJenkinsJob
    jenkins >> Edge(color="red", style="bold", label="If job result 'FAILED'", fontsize="15") >> slack