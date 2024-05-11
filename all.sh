if [ -e "/var/run/step1_done" ]; then
  sudo rm "/var/run/step1_done"
  bash "$HOME/autosetup/step2.sh" >> "$HOME/autosetup/logs/log.txt"


elif [ -e "/var/run/step2_done" ]; then
  sudo rm "/var/run/step2_done"
  bash "$HOME/autosetup/step3.sh" >> "$HOME/autosetup/logs/log.txt"

else
  sudo apt update -y
  sudo apt upgrade -y
  #first run
  echo "Cleaning old logs..."
  sudo rm -r "$HOME/autosetup/logs/"
  mkdir "$HOME/autosetup/logs/"
  sudo rm "/var/run/step1_done"
  sudo rm "/var/run/step2_done"
  sudo rm "/var/run/step3_done"
  sed -i '/bash $HOME/autosetup/all.sh/d' ~/.bashrc
  
  echo "Setupping permissions..."
  chmod +x "$HOME/autosetup/step1.sh"
  chmod +x "$HOME/autosetup/step2.sh"
  chmod +x "$HOME/autosetup/step3.sh"
  sudo echo "$USER ALL=(ALL) NOPASSWD: $HOME/autosetup/all.sh" | sudo EDITOR='tee -a' visudo
  sudo echo "$USER ALL=(ALL) NOPASSWD: $HOME/autosetup/step1.sh" | sudo EDITOR='tee -a' visudo
  sudo echo "$USER ALL=(ALL) NOPASSWD: $HOME/autosetup/step2.sh" | sudo EDITOR='tee -a' visudo
  sudo echo "$USER ALL=(ALL) NOPASSWD: $HOME/autosetup/step3.sh" | sudo EDITOR='tee -a' visudo

  echo "bash $HOME/autosetup/all.sh" >> ~/.bashrc




  
  echo "Running step1...."
  bash "$HOME/autosetup/step1.sh" >> "$HOME/autosetup/logs/log.txt" &  sudo tail -f "$HOME/autosetup/logs/log.txt"


fi
