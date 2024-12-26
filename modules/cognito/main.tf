resource "aws_cognito_user_pool" "this" {
  name = "one-stop-app-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]
}



#Cognito User Pool Client

resource "aws_cognito_user_pool_client" "this" {
  name         = "one-stop-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]

  allowed_oauth_flows       = ["code"]
  allowed_oauth_scopes      = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = ["https://your-frontend-domain.com/callback"] # Replace with your frontend URL
  logout_urls   = ["https://your-frontend-domain.com/logout"]  # Replace with your frontend URL
}
