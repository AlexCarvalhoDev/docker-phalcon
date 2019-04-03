# docker-phalcon
```bash
git clone https://github.com/AlexCarvalhoDev/docker-phalcon.git
cd docker-phalcon

docker build -t phalcon .

docker run -d -v PROJECT_PATH:/var/www/html --name PROJECT_NAME -p 80:80 phalcon
```
