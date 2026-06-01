# Managing Spotify Playlists with Terraform

This project demonstrates how Terraform can be used to automate the creation and management of Spotify playlists. By leveraging Infrastructure as Code (IaC) principles, you can efficiently organize, update, and maintain multiple playlists without manual effort. Terraform simplifies playlist management, making it easier to customize your music library and keep your collections consistent and scalable. Instead of manually creating and modifying playlists, you can define them as code and let Terraform handle the provisioning and updates.

## Follow the step-by-step guide below to get started:

# Managing Spotify Playlists with Terraform

## Project Overview

This project demonstrates how to use **Terraform** to automate the creation and management of Spotify playlists. Instead of manually creating playlists in Spotify, you can define them as code and let Terraform provision and manage them for you.

This is a great beginner-friendly Infrastructure as Code (IaC) project that introduces:

- Terraform
- API Authentication
- Provider Configuration
- Resource Management
- Automation Concepts

---

# Prerequisites

Before starting, ensure the following tools and accounts are ready:

## 1. Terraform

Install Terraform on your machine.

Verify the installation:

```bash
terraform -v
```

Expected output:

```bash
Terraform v1.x.x
```

---

## 2. Docker

Install Docker Desktop and ensure it is running.

Verify:

```bash
docker --version
```

---

## 3. Spotify Account

Create or use an existing Spotify account.

A Premium subscription is **not required**.

---

## 4. Spotify Developer Account

Visit:

https://developer.spotify.com

Log in using your Spotify account.

---

## 5. Visual Studio Code (Optional)

VS Code provides syntax highlighting and Terraform extensions that make editing easier.

---

# Step 1: Create the Terraform Project

Create a project directory:

```bash
mkdir spotify-terraform
cd spotify-terraform
```

Create the main Terraform file:

```bash
touch main.tf
```

Project structure:

```text
spotify-terraform/
├── main.tf
└── .env
```

---

# Step 2: Configure the Spotify Provider

Terraform uses providers to interact with external systems.

Add the Spotify provider configuration inside `main.tf`:

```terraform
provider "spotify" {
  api_key = "YOUR_API_KEY"
}
```

At this point, you do not yet have the API key.

The next steps will help generate it.

---

# Step 3: Create a Spotify Application

Navigate to:

https://developer.spotify.com/dashboard

---

## Create a New Application

Click:

```text
Create App
```

Example:

| Field | Value |
|---------|---------|
| Name | My Playlist through Terraform |
| Description | Create multiple Spotify playlists using Terraform |

---

## Configure Redirect URI

Add:

```text
http://localhost:27228/spotify_callback
```

This URL allows Spotify to return an authorization token to your local machine.

Save the settings.

---

# Step 4: Obtain Client ID and Client Secret

After creating the application:

1. Open the application settings.
2. Copy:

```text
Client ID
Client Secret
```

These credentials will be used to authenticate Terraform against Spotify's API.

Example:

```text
Client ID: abc123xyz
Client Secret: xxxxxx
```

Keep these values secure.

---

# Step 5: Store Credentials Securely

Create a file named:

```text
.env
```

Add:

```bash
SPOTIFY_CLIENT_ID=<your_client_id>
SPOTIFY_CLIENT_SECRET=<your_client_secret>
```

Example:

```bash
SPOTIFY_CLIENT_ID=abc123xyz
SPOTIFY_CLIENT_SECRET=secret123
```

Purpose:

- Avoid hardcoding secrets
- Improve security
- Simplify credential management

---

# Step 6: Generate the Spotify API Key

The Spotify Terraform provider requires an API key.

Instead of generating one manually, the project uses a Docker-based authorization proxy.

---

## Run the Authorization Proxy

Make sure Docker Desktop is running.

Execute:

```bash
docker run --rm -it \
-p 27228:27228 \
--env-file .env \
ghcr.io/conradludgate/spotify-auth-proxy
```

### What This Command Does

| Option | Purpose |
|----------|----------|
| --rm | Remove container after exit |
| -it | Interactive terminal |
| -p 27228:27228 | Expose local port |
| --env-file .env | Load Spotify credentials |
| spotify-auth-proxy | Authentication helper |

---

## Authenticate with Spotify

The container will output a URL.

Example:

```text
Open the following URL:
https://accounts.spotify.com/authorize/...
```

Open the URL in your browser.

---

### Grant Permissions

Spotify will ask:

```text
Do you authorize this application?
```

Click:

```text
Allow
```

---

### Authorization Successful

After successful login:

```text
Authorization Successful
```

The terminal will display an API token similar to:

```text
spotify_api_key=xxxxxxxxxxxxxxxx
```

Copy this value.

---

# Step 7: Update Terraform Provider

Replace the placeholder API key:

```terraform
provider "spotify" {
  api_key = "xxxxxxxxxxxxxxxx"
}
```

---

# Step 8: Create Playlists

Example Terraform resource:

```terraform
resource "spotify_playlist" "devops_playlist" {
  name        = "DevOps Learning"
  description = "Terraform managed playlist"
  public      = true
}
```

You can create multiple playlists:

```terraform
resource "spotify_playlist" "kubernetes" {
  name = "Kubernetes Playlist"
}

resource "spotify_playlist" "terraform" {
  name = "Terraform Playlist"
}

resource "spotify_playlist" "aws" {
  name = "AWS Playlist"
}
```

---

# Step 9: Initialize Terraform

Initialize the project:

```bash
terraform init
```

Terraform will:

- Download providers
- Create local state
- Prepare the working directory

Expected output:

```text
Terraform has been successfully initialized!
```

---

# Step 10: Review the Execution Plan

Check what Terraform intends to create:

```bash
terraform plan
```

Example:

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

---

# Step 11: Apply the Configuration

Create the playlists:

```bash
terraform apply
```

Confirm:

```text
Enter a value:
```

Type:

```text
yes
```

Terraform will create the playlists inside Spotify.

---

# Step 12: Verify in Spotify

Log in to your Spotify account.

Navigate to:

```text
Your Library → Playlists
```

You should see:

- DevOps Learning
- Kubernetes Playlist
- Terraform Playlist
- AWS Playlist

or any playlists defined in your Terraform configuration.

---

# Terraform Workflow Summary

```text
Spotify Developer App
          │
          ▼
Client ID + Secret
          │
          ▼
.env File
          │
          ▼
Docker Auth Proxy
          │
          ▼
Spotify API Key
          │
          ▼
Terraform Provider
          │
          ▼
terraform init
          │
          ▼
terraform apply
          │
          ▼
Spotify Playlists Created
```

---

# Learning Outcomes

After completing this project, you will understand:

- Terraform Providers
- Infrastructure as Code (IaC)
- API Authentication
- Secret Management
- Resource Creation
- Terraform Workflow
- State Management
- Automation Concepts

This project is an excellent beginner-to-intermediate Terraform project because it demonstrates how Terraform can manage resources beyond traditional cloud infrastructure.


https://callmeanurag.hashnode.dev/playlists-on-autopilot-manage-spotify-with-terraform