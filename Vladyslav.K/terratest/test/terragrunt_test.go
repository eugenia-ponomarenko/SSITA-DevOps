package test

import (
	"crypto/tls"
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

/*
USAGE
go test -v -run TestTerragruntMyconfig -timeout 30m
*/
func TestTerragruntMyconfig(t *testing.T) {
	// website::tag::3:: Construct the terraform options with default retryable errors to handle the most common retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1:: Set the path to the Terragrunt module that will be tested.
		TerraformDir: "../terragrunt/test",
		// website::tag::2:: Set the terraform binary path to terragrunt so that terratest uses terragrunt instead of terraform. You must ensure that you have terragrunt downloaded and available in your PATH.
		TerraformBinary: "terragrunt",
	})
	// Options for output lb dns
	terraformOptionsOutput := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1:: Set the path to the Terragrunt module that will be tested.
		TerraformDir: "../terragrunt/test/alb",
		// website::tag::2:: Set the terraform binary path to terragrunt so that terratest uses terragrunt instead of terraform. You must ensure that you have terragrunt downloaded and available in your PATH.
		TerraformBinary: "terragrunt",
	})

	// website::tag::6:: Clean up resources with "terragrunt destroy" at the end of the test.
	defer terraform.TgDestroyAllE(t, terraformOptions)

	// website::tag::4:: Run "terragrunt apply". Under the hood, terragrunt will run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.TgApplyAllE(t, terraformOptions)

	// website::tag::5:: Run `terraform output` to get the values of output variables and check they have the expected values.
	lbDnsName := terraform.Output(t, terraformOptionsOutput, "lb_dns_name")
	lbDnsNameURL := fmt.Sprintf("http://%s/citizen/", lbDnsName)
	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}
	// It can take a minute or so for the Instance to boot up, so retry a few times
	maxRetries := 300
	timeBetweenRetries := 10 * time.Second

	instanceText := `<!DOCTYPE html>
<html>
<head>
	<link rel=stylesheet href="//fonts.googleapis.com/css?family=Roboto:400,500,700,400italic|Material+Icons">
	<meta charset=utf-8>
	<meta name=viewport content="width=device-width,initial-scale=1">
	<title>Geo Citizen</title>
	<link rel="shortcut icon" type=image/ico href=./static/favicon.ico>
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDp8yH1-R9n8NQ2E8BUBiG5j7dvF_vSPMk&libraries=places"></script>
	<link href=./static/css/app.b2057eb25185abc87aa1cb6e9cdf8e44.css rel=stylesheet>
</head>
<body>
<div id=app></div>
<script type=text/javascript src=./static/js/manifest.2ae2e69a05c33dfc65f8.js></script>
<script type=text/javascript src=./static/js/vendor.9ad8d2b4b9b02bdd427f.js></script>
<script type=text/javascript src=./static/js/app.6313e3379203ca68a255.js></script>
</body>
</html>`

	// Verify that we get back a 200 OK with the expected instanceText
	http_helper.HttpGetWithRetry(t, lbDnsNameURL, &tlsConfig, 200, instanceText, maxRetries, timeBetweenRetries)

}
