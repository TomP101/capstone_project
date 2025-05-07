pipeline {
  agent any

  environment {
    AWS_REGION = 'eu-north-1'
    TF_BUCKET  = 'your-terraform-state-bucket'
  }

  tools {
    terraform 'terraform'
  }

  parameters {
    booleanParam(name: 'DESTROY', defaultValue: false, description: 'Enable destroy stage')
  }

  stages {
    stage('Init & Validate') {
      steps {
        sh '''
          cd envs/dev
          terraform init \
            -backend-config="bucket=${TF_BUCKET}" \
            -backend-config="region=${AWS_REGION}"
          terraform fmt -check -recursive
          terraform validate
        '''
      }
    }

    stage('Plan') {
      steps {
        sh '''
          cd envs/dev
          terraform plan -out=tfplan
        '''
        archiveArtifacts artifacts: 'envs/dev/tfplan'
      }
    }

    stage('Apply') {
      when { branch 'main' }
      steps {
        input message: 'Approve apply to dev?'
        sh '''
          cd envs/dev
          terraform apply -auto-approve tfplan
        '''
      }
    }

    stage('Destroy') {
      when { expression { params.DESTROY } }
      steps {
        input message: 'Approve destroy of dev?'
        sh '''
          cd envs/dev
          terraform destroy -auto-approve
        '''
      }
    }
  }
}
