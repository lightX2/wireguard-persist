cd /usr/src/
git clone https://github.com/lightX2/wireguard-persist.git
cd wireguard-persist
rm wg-persistent.deb
./build-deb.sh
dpkg -i wg-persistent.deb
