# Basic Usage
## 1. Create instance
### Carrier Selection:
> * [Vultr](https://www.vultr.com)
> * [Bandwagon](https://bwh1.net)
> * [Hostwinds](https://clients.hostwinds.com)

### OS Version
> * == Ubuntu 16.04(for lotserver scheme)
> * \>= Ubuntu 18.04(for bbr-normal scheme)

## 2. Prepare Domain and Analyze
Apply for a domain from carriers (Aliyun,...)
Domain Sample: [aoiheaven.ren](https://aoiheaven.ren)

## 3. Don't forget update DNS records
I choose [cloudflare](https://dash.cloudflare.com) for study.
But recommend to keep DNS the same with [Aliyun](https://cn.aliyun.com) manager.

## 3. Login Server as root (Telnet/SSH)
```bash
ssh-keygen -o  # First generate SSH Public Key (Could skip if generate before)
rm -rf ~/.ssh/known_hosts
# Copy public key into server
ssh-copy-id -i ~/.ssh/id_rsa.pub -p <port> <username>@<ipv4-address>
```

## 4. Run Script
```bash
git clone https://github.com/mjwangg/aoiheavenV2rayBackup.git
cd aoiheavenV2rayBackup
bash rebuild.sh
```

