mkdir -p $HOME/.kube
sudo chown -f -R $USER $HOME/.kube
microk8s config > $HOME/.kube/config

microk8s.status --wait-ready

kubectl get all --all-namespaces

#abilita le addons della community
microk8s.enable community

#abilitare altri pacchetti
microk8s.enable dns helm3 hostpath-storage ingress registry prometheus metrics-server linkerd
# !!! prima di eseguire il comando successivo aspettare che tutti i servizi siano in corso (running) !!!

microk8s.status --wait-ready


#per creare degli alias (quando chiamo helm3 è come se chiamassi microk8s.helm3, per es)
sudo snap alias microk8s.helm3 helm3
sudo snap alias microk8s.linkerd linkerd

#check del servizio linkerd 
linkerd check

kubectl top pods --all-namespaces


kubectl wait --for=condition=Ready --timeout=10m pod --all --all-namespaces

sudo apt-get install -y git curl jq

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget \
    curl llvm git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash
# When finished, edit ~/.bash_profile // ~/.profile // ~/.bashrc as the installer proposes.
# In general, it means to append the following lines to ~/.bashrc:
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


git clone --branch release/3.0.0  https://labs.etsi.org/rep/tfs/controller.git ~/tfs-ctrl

microk8s.status --wait-ready

cd ~/tfs-ctrlf
source my_deploy.sh
./deploy/all.sh


touch ~/autosetup/step2_done.txt
echo -e "step 2 done"


sudo touch "/var/run/step2_done"
sudo reboot
