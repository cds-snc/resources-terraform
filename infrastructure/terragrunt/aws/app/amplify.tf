resource "aws_amplify_app" "learning_resources" {
  name       = "Learning Resources"
  repository = "https://github.com/cds-snc/resources-ressources"

  # Github personal access token
  # -- needed when setting up amplify or making changes
  access_token = var.gh_access_token

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd app
            - cp .contentful.json.sample .contentful.json
            - npm install --legacy-peer-deps
        build:
          commands:
            - npm run generate
      artifacts:
        baseDirectory: app/dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV                         = var.env
    DOMAIN_EN                   = var.domain_name
    DOMAIN_FR                   = var.fr_domain_name
    contentful_cda_access_token = var.contentful_cda_access_token
    contentful_space_id         = var.contentful_space_id
    GOOGLE_ANALYTICS_ID         = var.google_analytics_id
    GOOGLE_TAG_MANAGER_ID       = var.google_tag_manager_id
    SENTRY_DSN                  = var.sentry_dsn

    PREVIEW_ENV = "false"

    # Feature flags
    F_HEADLINE     = "true"
    F_HEADLINE_ALT = "false"
  }

  enable_auto_branch_creation = true
  enable_branch_auto_deletion = true

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "feature*/",
    "release*",
    "fix*",
    "ci*"
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build             = true
    enable_pull_request_preview   = true
    pull_request_environment_name = "rc"
    stage                         = "PRODUCTION"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.learning_resources.id
  branch_name = "main"

  framework = "NuxtJS"

  # Could be one of: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST
  stage = "PRODUCTION"

  display_name = "production"

  enable_pull_request_preview = false
}

resource "aws_amplify_domain_association" "learning_resources_en" {

  app_id = aws_amplify_app.learning_resources.id
  domain_name = var.domain_name

  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
}

resource "aws_amplify_domain_association" "learning_resources_fr" {

  app_id      = aws_amplify_app.learning_resources.id
  domain_name = var.fr_domain_name

  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
}


resource "aws_amplify_branch" "lr_staging" {

  app_id      = aws_amplify_app.learning_resources.id
  branch_name = "staging"

  framework = "NuxtJS"

  # Could be one of: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST
  stage = "BETA"

  display_name = "staging"

  enable_pull_request_preview = true

  pull_request_environment_name = "PULL_REQUEST"

  environment_variables = {
    ENV                         = var.env
    DOMAIN_EN                   = "staging.${var.domain_name}"
    DOMAIN_FR                   = "staging.${var.fr_domain_name}"
  }
}

resource "aws_amplify_domain_association" "learning_resources_staging_en" {

  app_id = aws_amplify_app.learning_resources.id
  domain_name = "staging.${var.domain_name}"

  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.lr_staging.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.lr_staging.branch_name
    prefix      = "www"
  }
}

resource "aws_amplify_domain_association" "learning_resources_staging_fr" {

  app_id = aws_amplify_app.learning_resources.id
  domain_name = "staging.${var.fr_domain_name}"

  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.lr_staging.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.lr_staging.branch_name
    prefix      = "www"
  }
}