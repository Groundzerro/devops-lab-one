#!/bin/bash
set -eux

# ========== COMMON INIT (devops user, SSH, /etc/hosts) ==========

if ! id devops &>/dev/null; then
  useradd -m -s /bin/bash devops
fi

echo "devops ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devops
chmod 440 /etc/sudoers.d/devops

mkdir -p /home/devops/.ssh
cat << 'EOF' > /home/devops/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmDy7Bc6Y6RE4swLp8pZcBp6Tp7peo7wo5Hxu6QaN67AQNx0X+aZfFZov/jxduAAykEKCkZU6HgcKaYyi4vk1RME3cFI0QhFlIGJi25JmI6e1qKHc7Ijay6/PCVzwt+R5aghgsspte7V/fU+gMj/N4wg/p8TGw5v/L4dMxQpjANMZjLN7bfTQqLguKieGEerPU0j11wPEiAv9WlQaCMG8a3kaye0vep502mhWqLTfF1P0An9TFug9H4BpR0tFuh5OCP5vMfpKaGPd9gWDVH4YuHAno7k20zVQe0XORd2anJY69IGPVHXN/if3dg8WWRL1AsWU0mE9MTX/gwoqvZbAPB18EZ3/r52cz15fyjul6Dh6Bw4SLgs1IsScUBbsU21I3eUEN9MOmb1PdloJfx6df6RulaH6NvzlZhiTjL51e/xx6rfxf50z086CANxOsbG7z9kvQ8XEUZe2G5d3fAgKX7F3cEdedpHzTx+/qq2rSD1uoujRKQIFKFVsDqeFw6RPwJdOMtnLoIlPuQXBJyUlqstfKlga48AWnrdZmY6uuJNhRTUqpDYjZ5YckgABWsyf5Vejt1Kx6q1xgQHW3t+P6q/RgGbchqOJruWUsj/TDNxbtjPFBuBPuurPLD+pJoUCN2X/KQm2Q5ftHoj5E3FXSSCYKdhAjs9IHcd/Fkbfkjw== devops-lab-key
EOF

chown -R devops:devops /home/devops/.ssh
chmod 700 /home/devops/.ssh
chmod 600 /home/devops/.ssh/authorized_keys

cat << 'EOF' >> /etc/hosts
10.0.1.10  jenkins-master
10.0.1.11  tomcat
10.0.1.12  sonarqube
10.0.1.13  nexus
10.0.1.14  maven
10.0.1.15  jenkins-agent
EOF


# ========== NEXUS SETUP (Docker-based) ==========

apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
systemctl start docker

# Allow devops to use docker
usermod -aG docker devops || true

# Create data directory for Nexus
mkdir -p /nexus-data
chown -R 200:200 /nexus-data

# Run Nexus3 container
docker run -d --name nexus3 \
  -p 8081:8081 \
  -v /nexus-data:/nexus-data \
  sonatype/nexus3:latest
