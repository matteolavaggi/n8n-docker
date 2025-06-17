# n8n Docker with ngrok Integration

![n8n Docker with ngrok](./img/twins-n8n-docker.png)

A Docker-based n8n automation platform setup with automatic ngrok tunnel integration for easy webhook access and external connectivity.

**Developed by**: [Matteo Lavaggi](https://matteolavaggi.it) | [2wins.agency](https://2wins.agency)

## 🚀 What This Project Does

This project provides a complete n8n automation platform running in Docker with:

- **Automatic ngrok tunnel setup** for external webhook access
- **Public URL generation** for webhook integrations
- **Easy start/stop scripts** for development workflow
- **Environment-based configuration** with `.env` file support
- **Docker Desktop integration** for easy container management

Perfect for developers who need to:
- Test webhooks from external services
- Share n8n workflows with team members
- Develop automation workflows that require public URLs
- Run n8n in a containerized environment

## 📋 Prerequisites

### 1. Docker Installation

**Option A: Docker Desktop (Recommended for Windows/Mac)**
- Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Follow the installation wizard
- Ensure Docker Desktop is running

**Option B: Docker Engine (Linux)**
- Follow the [official Docker installation guide](https://docs.docker.com/engine/install/)
- Install Docker Compose: `sudo apt-get install docker-compose-plugin`

### 2. ngrok Installation

1. **Download ngrok**
   - Visit [ngrok.com/download](https://ngrok.com/download)
   - Download the version for your operating system
   - Extract the executable to a folder in your PATH

2. **Verify Installation**
   ```bash
   ngrok version
   ```

### 3. ngrok Account Setup

1. **Create Account**
   - Sign up at [ngrok.com](https://ngrok.com/)
   - Verify your email address

2. **Get Authentication Token**
   - Log in to your ngrok dashboard
   - Navigate to "Your Authtoken" section
   - Copy your authentication token

## 🛠️ Installation

1. **Clone or Download**
   ```bash
   git clone <repository-url>
   cd n8n-docker
   ```

2. **Create Environment File (Optional)**
   Create a `.env` file in the project root:
   ```env
   NGROK_AUTHTOKEN=your_ngrok_auth_token_here
   ```
   
   > **Note**: If you don't create a `.env` file, the script will ask for your token each time.

3. **Configure Docker Compose (Optional)**
   Review and modify `docker-compose.yml` if needed for your specific requirements.

## 🎯 Usage

### Starting n8n with ngrok

Run the start script:
```bash
# Windows
startwithngrok.bat
```

**What happens:**
1. Checks for ngrok installation
2. Configures ngrok authentication (from `.env` or user input)
3. Starts ngrok tunnel on port 5678
4. Retrieves the public ngrok URL
5. Updates Docker Compose with the webhook URL
6. Starts the n8n container
7. Displays all relevant URLs

### Stopping n8n and ngrok

Run the stop script:
```bash
# Windows
stopwithngrok.bat
```

**What happens:**
1. Stops the n8n container (keeps it visible in Docker Desktop)
2. Terminates all ngrok processes
3. Optionally resets webhook URL to localhost

### Accessing n8n

After starting, you can access n8n at:
- **Local**: http://localhost:5678
- **Public**: https://your-ngrok-url.ngrok-free.app (displayed in terminal)

## 📁 Project Structure

```
n8n-docker/
├── docker-compose.yml      # Docker Compose configuration
├── startwithngrok.bat     # Start script with ngrok integration
├── stopwithngrok.bat      # Stop script
├── .env                   # Environment variables (optional)
├── n8n.local.url         # Local URL reference
├── start.bat             # Basic start script (without ngrok)
└── README.md             # This file
```

## ⚙️ Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# ngrok Configuration
NGROK_AUTHTOKEN=your_ngrok_auth_token_here

# n8n Configuration (optional)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_password_here
```

### Docker Compose Customization

Modify `docker-compose.yml` to customize:
- Port mappings
- Volume mounts
- Environment variables
- n8n configuration

## 🔧 Troubleshooting

### Common Issues

**ngrok not found**
- Ensure ngrok is installed and in your PATH
- Try running `ngrok version` to verify installation

**Docker permission denied**
- On Linux, add your user to the docker group:
  ```bash
  sudo usermod -aG docker $USER
  ```
- Log out and back in for changes to take effect

**Port already in use**
- Check if another service is using port 5678
- Stop the conflicting service or change the port in docker-compose.yml

**ngrok tunnel not working**
- Verify your authtoken is correct
- Check your ngrok account limits
- Ensure you have an active internet connection

### Logs and Debugging

**View n8n logs:**
```bash
docker compose logs -f
```

**Check ngrok status:**
```bash
curl http://127.0.0.1:4040/api/tunnels
```

**View running containers:**
```bash
docker ps
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### License Scope and Exclusions

**What's covered by this license:**
- The Docker Compose configuration files
- The batch scripts (`startwithngrok.bat`, `stopwithngrok.bat`, etc.)
- The project structure and documentation
- Integration logic and automation scripts

**What's NOT covered by this license:**
- **n8n**: Licensed under the [n8n Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md)
- **Docker**: Licensed under Apache License 2.0
- **ngrok**: Licensed under ngrok Terms of Service
- **Other third-party tools and dependencies**: Each maintains its own licensing terms

This project provides integration and automation scripts only. Users must comply with the individual licenses of all underlying technologies (n8n, Docker, ngrok, etc.) when using this project.

## 🙏 Acknowledgments

- [n8n](https://n8n.io/) - The workflow automation platform
- [ngrok](https://ngrok.com/) - Secure tunnel to localhost
- [Docker](https://www.docker.com/) - Containerization platform

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Review the [n8n documentation](https://docs.n8n.io/)
3. Check [ngrok documentation](https://ngrok.com/docs)
4. Open an issue in this repository

---

**Happy Automating! 🎉** 