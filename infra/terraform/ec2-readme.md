```bash
# Access ec2
ssh -i christian-ec2-key-pair.pem ec2-user@13.63.100.121

# cpu info
lscpu

# memory RAM info
free -h

# List all disks
lsblk

# Disk usage
df -h # -h human readable
sudo fdisk -l # detailed disk info

pwd # show current path
```

```bash
# Clone repo
git clone https://github.com/ChristianKatka/lime-ai
cd lime-ai/vLLM
```

```bash
# Create .env file inside vLLM folder for docker compose
cat <<EOF > .env

<COPY_HERE_ENV_VALUES_FROM_YOUR_NOTES>

EOF
```

```bash
# Start services
docker compose up -d

# Check logs
docker compose logs -f

# Stop services
docker compose down
```
