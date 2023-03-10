# opa-policies

Repository contains examples of **policy as code** with the use of OPA (Open Policy Agent).

## Examples

### Local file

Initialize Terraform:

```
cd examples/local-file/infra
terraform init
```

Prepare Terraform plan in JSON format in 2 steps:

```
terraform plan --out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
```

or use below command:

```
terraform plan --out tfplan.binary && terraform show -json tfplan.binary > tfplan.json
```

Execute Rego policy for generated plan to get final result and score:

```
opa exec --decision terraform/analysis/allow --bundle ../policy tfplan.json
opa exec --decision terraform/analysis/score --bundle ../policy tfplan.json
```

or use below command to get full result:

```
opa exec --decision terraform/analysis --bundle ../policy tfplan.json
```

In order to execute Sentinel policy, prepare JSON in differet place:

```
mkdir ../policy/test/terraform_basic
terraform plan --out tfplan.binary && terraform show -json tfplan.binary > ../policy/test/terraform_basic/tfplan.json
terraform plan --out tfplan.binary && terraform show -no-color tfplan.binary > ../policy/test/terraform_basic/tfplan.hcl
```

and execute Sentinel policy:

```
cd ../policy
sentinel test terraform_basic.sentinel
```

### AWS Lambda

TODO: prepare example Terraform code to deploy Lambda

TODO: prepare example Rego policy to check resource being deployed in AWS

## Links

* [OPA (Open Policy Agent) - Terraform](https://www.openpolicyagent.org/docs/latest/terraform/)
* [Defining OPA Policies](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/opa)
* [Validate Infrastructure and Enforce OPA Policies](https://developer.hashicorp.com/terraform/tutorials/cloud/validation-enforcement)
* [Pre-deployment Policy Checks for Terraform using OPA (Open Policy Agent)](https://medium.com/airwalk/pre-deployment-policy-checks-for-terraform-using-opa-open-policy-agent-96e2ae60f9f5)
* [The Rego Playground](https://play.openpolicyagent.org/)
* [Rego - How Do I Write Policies?](https://www.openpolicyagent.org/docs/v0.13.5/how-do-i-write-policies/)
* [What Is Policy-as-Code?](https://www.paloaltonetworks.com/cyberpedia/what-is-policy-as-code)
* [Sentinel - Policy as Code](https://docs.hashicorp.com/sentinel/concepts/policy-as-code)
* [What is Policy-as-Code? An Introduction to Open Policy Agent](https://blog.gitguardian.com/what-is-policy-as-code-an-introduction-to-open-policy-agent/)