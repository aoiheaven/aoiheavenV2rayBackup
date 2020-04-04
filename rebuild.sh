#! /bin/bash
TOL_STEP=6
DOMAIN="aoiheaven.ren"
LIS_PORT=443
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${YELLOW}[1/"${TOL_STEP}"] ${GREEN}Updates the package lists for upgrades...${NC}"
apt-get update && apt-get upgrade -y && echo ""

echo -e "${YELLOW}[2/"${TOL_STEP}"] ${GREEN}Updates config(~/.bashrc & ~/.inputrc) in server...${NC}"
mv ~/.bashrc ~/.bashrc_bak
cp ./bashrc_server ~/.bashrc
cp ./inputrc_server ~/.inputrc
echo ""

echo -e "${YELLOW}[3/"${TOL_STEP}"] ${GREEN}Install V2ray & nginx & acme.sh...${NC}"
bash <(curl -L -s https://install.direct/go.sh)
curl  https://get.acme.sh | sh
apt-get install -y socat
apt-get install -y nginx
echo ""

source ~/.bashrc
echo -e "${YELLOW}[4/"${TOL_STEP}"] ${GREEN}Install certificate and key for my domain${CYAN}("$DOMAIN")${GREEN}...${NC}"
service v2ray stop
service nginx stop
~/.acme.sh/acme.sh --issue -d ${DOMAIN} --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d ${DOMAIN} --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
~/.acme.sh/acme.sh --upgrade  --auto-upgrade
echo ""

echo -e "${YELLOW}[5/"${TOL_STEP}"] ${GREEN}Updates config files of v2ray & nginx for tls...${NC}"
mv /etc/v2ray/config.json /etc/v2ray/config.json_bak
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_bak
cp ./config_v2ray_server /etc/v2ray/config.json
cp ./config_nginx_server /etc/nginx/sites-available/default
ln -s /etc/v2ray/config.json ~/config_v2ray
ln -s /etc/nginx ~/nginx
echo ""

echo -e "${YELLOW}[6/"${TOL_STEP}"] ${GREEN}Restart v2ray & nginx...${NC}"
service nginx restart
systemctl -a | grep nginx
service v2ray restart
systemctl -a | grep v2ray
echo ""

echo -e "${YELLOW}[7/"${TOL_STEP}"] ${GREEN}Choose one scheme to accelerate...${NC}"
echo -e "${GREEN}[1] -> BBR(normal)\n${GREEN}[2] -> lotserver(Need reboot and may destory)\n${GREEN}[3] -> No accelerate\n${NC}"
while true ; do
read -n1 -p "Which one? [1-3]"$'\n' doit 
	case $doit in  
	  1) echo -e $'\n'"${YELLOW}BBR-normal scheme: ${NC}"
		 cp ./enable_bbr.sh ~/
		 cd ~/
		 bash ~/enable_bbr.sh && cd -
		 echo -e "${GREEN}Enable BBR accelerate scheme !${NC}"
		 break ;; 
	  2) echo -e $'\n'"${YELLOW}Lotserver scheme: ${NC}" 
		 cp ./ruisu.sh ~/
		 cd ~/
		 bash ruisu.sh && cd -
		 break;; 
	  3) echo -e $'\n'"${YELLOW}No accelerate !${NC}"
		 break ;;
	  *) echo -e $'\n'"${RED}Unknown Choice...${NC}" ;; 
	esac
done

echo -e "${YELLOW}Domain: ${GREEN}"${DOMAIN}: ${LIS_PORT}"${NC}"
echo -e "${YELLOW}UUID & AlterId: ${GREEN}"
grep "\"id\":" ./config_v2ray
grep "\"alterId\":" ./config_v2ray
echo -e "${NC}"

echo "Must reboot server if want to enable accelerate scheme. Reboot now? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo -e $'\n'"${GREEN}Reboot Server...${NC}";
		reboot;
else
        echo -e $'\n'"${YELLOW}Please reboot server later manually.${NC}";
fi

