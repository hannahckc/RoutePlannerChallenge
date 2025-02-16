<h1> Route Planner Flask Application </h1>

<h2> Intro </h2>
This was created as part of a technical challenge assigned to me. The task was to create an API using any language, that had specific endpoints assigned. This was to be deployed using Terraform. I chose Python, and used Flask to define my endpoints.

<h2> Data info </h2>
The SQL script was supplied to me. It holds information on hyperspace gates, and the connections between them. I did slightly restructure the initial script to move the connections to a separate table, as this made more sense to me.

<h2> Endpoint requirements </h2>
<ul>
<li>
  <code>GET: /transport/{distance}?passengers={number}&parking={days} </code>

Returns the cheapest vehicle to use (and the cost of the journey) for the given distance (in AUs), number or passengers and days of parking (i.e. vehicle storage at the gate)
</li>

<li>
<code>GET: /gates</code>

Returns a list of gates with their information </li>

<li>
<code>GET: /gates/{gateCode}</code> 

Returns the details of a single gate 
</li>

<li><code>GET: /gates/{gateCode}/to/{targetGateCode}</code> 

Returns the cheapest route from gateCode to targetGateCode </li>
</ul>

<h2> Structure </h2>

The environment and application are created and run using Github actions. This runs on a Macos runner, which 
<ol>
<li> 
    Installs Homebrew, Postgres and AWS CLI 
</li>
<li> 
    Gets Github secrets to use and sets them as environment variables 
</li>
<li> 
    Initialises terraform 
</li>
<li> 
    Destroys Terraform resources (optional, if made changes to terraform files then will need to run this)
</li>
<li> 
    Applies terraform for RDS (Creates RDS instance where the Postgres DB will be stored) 
</li>
<li> 
    Applies terraform for ECR (Creates ECR instance for Flask app inside docker image to be stored) 
</li>
<li> 
    Takes the outputs from these runs and puts them in environment variables 
</li>
<li> 
    Runs the <b>deploy.sh</b> script, which 
    <ul>
    <li> 
        Builds the docker image and runs the flask app using <b>Dockerfile</b> within the flaskApp directory 
    </li>
    <li> 
        Pushes the docker image to the ECR instance 
    </li>
    <li> 
        Run the SQL script to populate the database </li>
    </ul>
<li> 
    Creates the ECS instance, passing in the ECR repo link so the docker image can be deployed on the ECS instance 
</li>
<li>   
    Extracts some values of the task (ie the docker image) running on ECS
</li>
<li>
    Runs pytest to run the Python tests to check the endpoints
</li>
</ol>

<h2> Set up </h2>

<h3> AWS IAM role </h3>
You will need an AWS account, and to create an IAM role. You can do this in the AWS console under IAM. You user should:
<ul>
<li>
    Have Programmatic access
</li>
<li>
    Have Admin permissions
</li>
<li> 
    You need to generate an AWS access key for them. <b> Make sure you save these in a file somewhere as you can only look at them once. </b>
</li>
</ul>

<h3> Github secrets </h3>
This code runs as a workflow on Github, so you will need to have a Github account to run it.
You will need to add the following secrets (check the names are exactly like this):
<ul>
<li> 
    <b>DB_USERNAME</b> - An RDS instance with a Postgres database is created. It requires you to set a username for the database.
</li>
<li> 
    <b>DB_PASSWORD</b> - Similary, a password that will be used to access the RDS.
</li>
<li>
    <b>AWS_ACCESS_KEY_ID</b> - The contents of your the access key you should have copied above.
</li>
<li>
    <b>AWS_SECRET_ACCESS_KEY</b> - The contents of the secret access key you copied above. These AWS credentials mean the commands are associated with your AWS account and are run by a user with the correct permissions.
</li>
</ul>

<h3> Create a VPC and subnets </h3>
For the RDS and ECS to run, you need to create a VPC with some public subnets. You can do this on the AWS console. 
<ul>
<li>
    Select <b>VPC and more </b>
</li>
<li>
    Give it a custom name if you want
</LI>
<li>
    Put in an IPv4 cidr block eg <code>10.0.0.0/16</code>
</li>
<li>
    Create at least 1 public subnet, no private ones
</li>
<li>
    Leave other defaults as they are
</li>
</ul>

<h3> Create Github runner </h3>
You need to create a runner for the Github actions to run on. Go to Settings -> Actions -> Runners and create a self-hosted runner. This should be <b>macOS</b> and <b>arm64</b>


<h3> Terraform variables </h3>
There are a couple of compulsory and some optional variables you can pass into terraform for setting up your ECR, RDS and ECS instances. 
<br><br>
Create a <b>terraform.tfvars</b> file in the terraform directory.
<br><br>
</h4>Compulsory</h4>

<ul>
<li>
    <b>vpc_id</b> - The ID of the VPC you created above 
</li>
<li>
    <b>public_subnets</b> - A list of the subnets associated with the VPC you created
</li>
</ul>

So your file might look like:
```
public_subnets = ["subnet-abc123", "subnet-g4b5"]

vpc_id = "vpc-sjfi1930"
```
<h4>Optional</h4>

You can also add other arguments to the tfvars file, if you dont want to use the defaults
<ul>
<li>
    project_name: Used in naming your AWS resources, security group etc. Default is route-planner.
</li>
<li>
    db_name: Name of Postgres database created on the RDS. Default is gatedb.
</li>
<li>
    repository_name: Name of the ECR repo that stores the Flask app and Docker code. Default is flask-app-repo
</li>
<li>
    env: eg testing, production. Used to determine size of RDS DB and also in naming of various resources. Default is testing
</li>
<li>
    region: Region for AWS resources to be created. <b>IMPORTANT: This must match the region of your VPC</b>. Default is eu-north-1.
</li>
<li>
    db_subnet_group_name: Determines which subnets will be used. This is set to 'default'. If you want your database to run on private subnets, you will need to create a aws_db_subnet_group, and a VPC with private subnets. For this task security was not a high priority so the default group is working okay.
</li>
</ul>

<h3> API docs </h3>

API documentation has been created used Swagger.

Once the app is up and running, you can access documentation and examples of the endpoints, visit
```
http://{ecs_public_ip}:8080/apidocs
```
You can retrieve the piblic IP of the task from the AWS console (ECS -> Clusters -> Task) or from the outputs of the Github actions.

<h3> Testing </h3>

Tests have been created using pytest for each of the endpoints. Currently there are permission issues I believe which means the pytest command is not running using Github actions. It can be run from your host machine like this, getting the variables from the Github actions log:
```
  aws ecs execute-command \
  --cluster ${ECS_CLUSTER_NAME} \
  --task ${TASK_ID} \
  --container ${CONTAINER_NAME} \
  --command "pytest" \
  --interactive
```