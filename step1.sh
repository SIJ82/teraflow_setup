sudo apt install python3 -y

# !Install MicroK8s! 1.2:
# intsllazione prerequisiti
sudo apt-get install -y ca-certificates curl gnupg lsb-release snapd jq

# installazione docker
sudo apt-get install -y docker.io docker-buildx

# per aggiungere ai registri l'occorrente
if [ -s /etc/docker/daemon.json ]; then cat /etc/docker/daemon.json; else echo '{}'; fi \
    | jq 'if has("insecure-registries") then . else .+ {"insecure-registries": []} end' -- \
    | jq '."insecure-registries" |= (.+ ["localhost:32000"] | unique)' -- \
    | tee tmp.daemon.json
sudo mv tmp.daemon.json /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json
sudo chmod 600 /etc/docker/daemon.json

# restart del servizio del docker
sudo systemctl restart docker

# installazione di MicroK8s
## Install MicroK8s
sudo snap install microk8s --classic --channel=1.24/stable

## Create alias for command "microk8s.kubectl" to be usable as "kubectl"
sudo snap alias microk8s.kubectl kubectl


## Verify status of ufw firewall
sudo ufw status

## If ufw is active, install following rules to enable access pod-to-pod and pod-to-internet
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

#Aggiunge i permessi per i docker e microk8s
sudo usermod -a -G docker $USER
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER $HOME/.kube

touch ~/autosetup/step1_done.txt
echo -e "Step1 finished, rebooting"

sudo touch "/var/run/step1_done"
sudo reboot











