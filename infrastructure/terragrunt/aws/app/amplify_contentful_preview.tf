resource "aws_amplify_app" "lr_contentful_preview" {
  count = var.env == "staging" ? 1 : 0

  name       = "LR Contentful Preview"
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
            - nvm install 16
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
    test:
      phases:
        preTest:
          commands:
            - cd app
            - npm ci --legacy-peer-deps
            - npm install --legacy-peer-deps -g pm2
            - npm install --legacy-peer-deps -g wait-on
            - npm install --legacy-peer-deps mocha mochawesome mochawesome-merge mochawesome-report-generator
            - pm2 start npm -- start
            - wait-on http://localhost:3000
        test:
          commands:
            - 'npx cypress run --reporter mochawesome --reporter-options "reportDir=cypress/report/mochawesome-report,overwrite=false,html=false,json=true,timestamp=mmddyyyy_HHMMss"'
        postTest:
          commands:
            - npx mochawesome-merge cypress/report/mochawesome-report/mochawesome*.json > cypress/report/mochawesome.json
            - pm2 kill
      artifacts:
        baseDirectory: app/dist
        configFilePath: '**/mochawesome.json'
        files:
          - '**/*.png'
          - '**/*.mp4'
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV                         = var.env
    DOMAIN_EN                   = "preview.${var.domain_name}"
    DOMAIN_FR                   = "preview.${var.fr_domain_name}"
    contentful_cda_access_token = var.contentful_cda_access_token
    contentful_cpa_access_token = var.contentful_cpa_access_token
    contentful_space_id         = var.contentful_space_id
    GOOGLE_ANALYTICS_ID         = var.google_analytics_id
    GOOGLE_TAG_MANAGER_ID       = var.google_tag_manager_id
    SENTRY_DSN                  = var.sentry_dsn

    PREVIEW_ENV = "true"

    # Feature flags
    F_HEADLINE     = "false"
    F_HEADLINE_ALT = "true"
  }

  enable_basic_auth      = true
  basic_auth_credentials = base64encode(var.contentfulprev_auth)


  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
  ]
}

resource "aws_amplify_branch" "lr_contentful_preview_staging" {
  count       = var.env == "staging" ? 1 : 0
  app_id      = one(aws_amplify_app.lr_contentful_preview[*].id)
  branch_name = "staging"

  framework = "NuxtJS"

  # Could be one of: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST
  stage = "PRODUCTION"

  display_name = "production"

  enable_pull_request_preview = false

  #   environment_variables = {
  #     ENV                         = var.env
  #     DOMAIN_EN                   = "preview.resources.cdssandbox.xyz"
  #     DOMAIN_FR                   = "preview.ressources.cdssandbox.xyz"
  #     contentful_cda_access_token = var.contentful_cda_access_token
  #     contentful_cpa_access_token = var.contentful_cpa_access_token
  #     GOOGLE_ANALYTICS_ID         = ""
  #     GOOGLE_TAG_MANAGER_ID       = var.google_tag_manager_id
  #     SENTRY_DSN                  = var.sentry_dsn
  #     PREVIEW_ENV                 = "true"
  #
  #     # Feature flags
  #     F_HEADLINE                  = "false"
  #     F_HEADLINE_ALT              = "true"
  #   }
}

resource "aws_amplify_domain_association" "lr_contentful_preview_en" {
  count       = var.env == "staging" ? 1 : 0
  app_id      = one(aws_amplify_app.lr_contentful_preview[*].id)
  domain_name = "preview.${var.domain_name}"

  wait_for_verification = false


  sub_domain {
    branch_name = one(aws_amplify_branch.lr_contentful_preview_staging[*].branch_name)
    prefix      = ""
  }

  sub_domain {
    branch_name = one(aws_amplify_branch.lr_contentful_preview_staging[*].branch_name)
    prefix      = "www"
  }
}

resource "aws_amplify_domain_association" "lr_contentful_preview_fr" {
  count       = var.env == "staging" ? 1 : 0
  app_id      = one(aws_amplify_app.lr_contentful_preview[*].id)
  domain_name = "preview.${var.fr_domain_name}"

  wait_for_verification = false


  sub_domain {
    branch_name = one(aws_amplify_branch.lr_contentful_preview_staging[*].branch_name)
    prefix      = ""
  }

  sub_domain {
    branch_name = one(aws_amplify_branch.lr_contentful_preview_staging[*].branch_name)
    prefix      = "www"
  }
}