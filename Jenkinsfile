pipeline {
  agent any

  tools {
    terraform 'terraform'
  }

  parameters {
    booleanParam(name: 'DESTROY', defaultValue: false, description: 'Enable destroy stage')
  }

  stages {
    stage('Init & Validate') {
      steps {
        dir('infra-aws') {
          sh 'terraform init'
          sh 'terraform fmt -check -recursive'
          sh 'terraform validate'
        }
      }
    }

    stage('Plan') {
      steps {
        dir('infra-aws') {
          sh 'terraform plan -out=tfplan'
        }
        archiveArtifacts artifacts: 'infra-aws/tfplan'
      }
    }

    stage('Apply') {
      when { branch 'main' }
      steps {
        input message: 'Approve apply to AWS infra?'
        dir('infra-aws') {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }

    stage('Destroy') {
      when { expression { params.DESTROY } }
      steps {
        input message: 'Approve destroy of AWS infra?'
        dir('infra-aws') {
          sh 'terraform destroy -auto-approve'
        }
      }
    }
  }
}
