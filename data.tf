data "aws_caller_identity" "current" {} #command to get the caller identity 

data "aws_iam_policy_document" "Key_policy" { # Snippet for policy writiing 
  statement {
    sid    = "allow root access to this key"
    effect = "Allow" # Allow or Deny
    principals {
      type        = "AWS" #service is for the aws account 
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"] #Kms anything granting him permission to do anything with this key
    resources = ["*"]     #Every resource
  }

}
