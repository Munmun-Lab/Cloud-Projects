Perfect! Here’s a **ready-to-copy version** you can directly paste into your `README.md` file:

````markdown
# Flask App Deployment with Docker and Self-Hosted Runner

## 1. Launch EC2
- Launch Ubuntu EC2 instance.
- SSH into instance:
```bash
ssh -i your-key.pem ubuntu@<ec2-public-ip>
````

## 2. Install Docker

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
docker --version
```

## 3. Setup Self-Hosted GitHub Runner

1. Go to GitHub → Settings → Actions → Runners → Add runner.
2. On EC2, download, extract, configure, and start the runner:

```bash
./config.sh --url <repo-url> --token <token>
./run.sh
```

## 4. Build and Deploy Docker Image

```bash
# Build Docker image
docker build -t <dockerhub_username>/flask-app:latest .

# Login and push to DockerHub
docker login
docker push <dockerhub_username>/flask-app:latest

# Run container
docker stop flask-app || true
docker rm flask-app || true
docker run -d -p 5000:5000 --name flask-app <dockerhub_username>/flask-app:latest
```

```
App is ready access with your url
http://34.239.127.148:5000/


```
<img width="1666" height="867" alt="image" src="https://github.com/user-attachments/assets/3e76a50f-5ac2-49e7-b573-c28269d6bd06" />
