set -e
apt update ; apt -y install python3-setuptools
node ./scripts/build-packages.js
cd ./gui ; npm install
cd ../core ; npm install
cd ../gui ; npm run build
cd ../extensions/vscode ; npm install
npx node scripts/prepackage-cross-platform.js --target darwin-arm64
npx node scripts/package.js --target darwin-arm64
