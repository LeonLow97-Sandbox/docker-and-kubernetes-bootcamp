# Creating a Production-Grade Workflow

- Development --> Testing --> Deployment --> Development

## Flow Specifics

1. Dev
    - Create/change features
    - Make changes on a non-master branch
    - Push to github
    - Create Pull Request to merge with master
2. Test
    - Code pushed to *Travis CI*
    - Tests run
    - Merge PR with master
3. Prod
    - Code pushed to Travis CI
    - Tests run
    - Deploy to AWS Elastic Beanstalk

- Docker is a tool in a normal development flow.
    - Docker makes some of these tasks a lot easier.
