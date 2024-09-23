# Push Secrets to GitHub Repository Secrets from an .env file

### Prerequisites

- GitHub CLI (gh) installed on your local machine. Authenticate it as well with your user / organisation.
- Access to a GitHub account with the necessary permissions to update repository secrets.
- Basic knowledge of Bash scripting and command-line operations.

### Directory Structure of this Project

```
push-secrets/
├── .env
├── .github.env
├── .gitignore
└── push_secrets.sh
```

### Files

> Check the .example.env files in the repository

- `.env` file containing all the secrets you want to push

```bash
DATABASE_URL=mysql://user:password@localhost:3306/dbname
API_KEY=123456789abcdef
SECRET_KEY=supersecretkey
```

- `.github.env` for the github api calls

```bash
export OWNER=your-github-username or organization-name
export REPO=your-repository-name
# classic token with read & write permissions of the repo scope for your repo
export GH_API_RW_REPO_SECRETS=your-gh-token
```

- `.gitignore`
```bash
.env
.github.env
```

### Running the script

- Make the script executable and run

```bash
chmod +x ./push_secrets.sh
```

- Run the script
```bash
./push_secrets.sh
# or `bash ./push_secrets.sh` if you didn't do step 1
```

If you followed all steps properly, you should see the output like this

```bash
Processing secret: DATABASE_URL
Secret 'DATABASE_URL' created/updated successfully.
Processing secret: API_KEY
Secret 'API_KEY' created/updated successfully.
Processing secret: SECRET_KEY
Secret 'SECRET_KEY' created/updated successfully.
```

### Additional Tips
- Integrate this script into your continuous integration pipeline to automatically update secrets when changes are detected.
- Accept OWNER and REPO as arguments to the file to allow use across different repositories easily, thereby simplifying the workflow.
- Integrate this script into your continuous integration pipeline to automatically update secrets when changes are detected.

### References
https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28#create-or-update-a-repository-secret

>Disclaimer: Ensure that you understand the security implications of automating secret management and handle all credentials responsibly. Always follow best practices for storing and transmitting sensitive information.
