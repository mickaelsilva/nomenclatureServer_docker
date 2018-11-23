FROM ubuntu:16.04
MAINTAINER UMMI
LABEL email="ummimicro@medicina.ulisboa.pt"

RUN apt-get update &&\
    apt-get install -y p7zip-full aptitude nginx redis-server postgresql git python3 python3-pip wget screen ufw && \
    apt-get autoclean -y
    
RUN DEBIAN_FRONTEND=noninteractive aptitude install --no-gui -y virtuoso-opensource
RUN python3 -m pip install --upgrade pip
#RUN ufw allow 'Nginx HTTP'


#RUN service virtuoso-opensource-6.1 status
#RUN service service virtuoso-opensource-6.1 restart



# setup the app
#RUN mkdir NS
WORKDIR /NS/
RUN pwd
RUN ls
RUN git clone https://github.com/B-UMMI/NS-1
RUN pip3 install -r ./NS_typon/requirements.txt

#route app and virtuoso in nginx to 80 port
COPY ./NS_typon/myconf.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-sites-enabled/default
RUN ln -s /etc/nginx/sites-available/myconf.conf /etc/nginx/sites-enabled/
RUN service nginx restart

COPY ./NS_typon/virtuoso.db /var/lib/virtuoso-opensource-6.1/db/
RUN service virtuoso-opensource-6.1 start
#RUN 'python3 -m venv flask'
