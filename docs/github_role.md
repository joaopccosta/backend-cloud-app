# Github Actions Role

The following are the policies that were manually attached to the IAM Role assumed by the GitHub Action Runners.

The policies themselves were attempted to be relatively tight, rather than just wildcarding all permissions. The exception is `ec2`, `eks`, `elasticloadbalancing`, because essentially we need almost all permissions on these to be able to create a working eks cluster.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "acm:ExportCertificate",
                "acm:GetAccountConfiguration",
                "acm:DescribeCertificate",
                "acm:RequestCertificate",
                "acm:PutAccountConfiguration",
                "acm:GetCertificate",
                "acm:UpdateCertificateOptions",
                "acm:AddTagsToCertificate",
                "acm:ListCertificates",
                "acm:RenewCertificate",
                "acm:ListTagsForCertificate"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeImport",
                "dynamodb:ListTables",
                "dynamodb:DescribeContributorInsights",
                "dynamodb:ListTagsOfResource",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:DeleteTable",
                "dynamodb:CreateTable",
                "dynamodb:DescribeGlobalTableSettings",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:TagResource",
                "dynamodb:DescribeTable",
                "dynamodb:DescribeGlobalTable",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:DescribeContinuousBackups",
                "dynamodb:DescribeExport",
                "dynamodb:DescribeKinesisStreamingDestination",
                "dynamodb:DescribeBackup",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeEndpoints",
                "dynamodb:UpdateTable",
                "dynamodb:DescribeTableReplicaAutoScaling"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "eks:*",
                "elasticloadbalancing:*",
                "sts:AssumeRoleWithWebIdentity"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicyVersion",
                "iam:ListRoleTags",
                "iam:DeleteGroup",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListOpenIDConnectProviderTags",
                "iam:DetachGroupPolicy",
                "iam:ListRolePolicies",
                "iam:DetachUserPolicy",
                "iam:DeleteOpenIDConnectProvider",
                "iam:PutGroupPolicy",
                "iam:ListPolicies",
                "iam:GetRole",
                "iam:GetPolicy",
                "iam:DeleteUserPolicy",
                "iam:AttachUserPolicy",
                "iam:DeleteRole",
                "iam:TagPolicy",
                "iam:GetUserPolicy",
                "iam:ListGroupsForUser",
                "iam:GetAccountName",
                "iam:GetOpenIDConnectProvider",
                "iam:GetRolePolicy",
                "iam:PutRolePermissionsBoundary",
                "iam:TagRole",
                "iam:ListPoliciesGrantingServiceAccess",
                "iam:DeletePolicy",
                "iam:ListInstanceProfileTags",
                "iam:ListInstanceProfilesForRole",
                "iam:DeleteRolePolicy",
                "iam:ListAttachedUserPolicies",
                "iam:ListAttachedGroupPolicies",
                "iam:ListPolicyTags",
                "iam:CreatePolicyVersion",
                "iam:ListGroupPolicies",
                "iam:ListRoles",
                "iam:DeleteUser",
                "iam:ListUserPolicies",
                "iam:ListInstanceProfiles",
                "iam:TagUser",
                "iam:CreateOpenIDConnectProvider",
                "iam:CreatePolicy",
                "iam:ListPolicyVersions",
                "iam:ListOpenIDConnectProviders",
                "iam:AttachGroupPolicy",
                "iam:PutUserPolicy",
                "iam:ListUsers",
                "iam:UpdateRole",
                "iam:GetUser",
                "iam:ListGroups",
                "iam:DeleteGroupPolicy",
                "iam:TagOpenIDConnectProvider",
                "iam:DeletePolicyVersion",
                "iam:TagInstanceProfile",
                "iam:ListUserTags"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "*"
        }
    ]
}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::backend-cloud-app-state-bucket",
                "arn:aws:s3:::backend-cloud-app-state-bucket/*"
            ]
        }
    ]
}
```
